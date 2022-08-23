defmodule Pento.Catalog.Product.Query do
  import Ecto.Query

  alias Pento.Catalog.Product
  alias Pento.Survey.Rating

  def base do
    Product
  end

  def with_user_ratings(user) do
    base()
    |> preload_user_ratings(user)
  end

  def preload_user_ratings(query, user) do
    ratings_query = Rating.Query.preload_user(user)

    query
    |> preload(ratings: ^ratings_query)
  end

  def with_average_ratings(query \\ base()) do
    query
    |> join_ratings
    |> average_ratings
  end

  defp join_ratings(query) do
    query
    |> join(:inner, [p], r in Rating, on: r.product_id == p.id)
  end

  defp average_ratings(query) do
    query
    |> group_by([p], p.id)
    |> select([p, r], {p.name, fragment("?::float", avg(r.stars))})
  end

  def products_with_average_ratings() do
    from p in Product,
      join: r in assoc(p, :ratings),
      group_by: p.id,
      select: {p.name, fragment("?::float", avg(r.stars))}
  end

  def products_by_user_age("18 and under") do
    products_by_users_age(year(18), year(0))
  end

  def products_by_user_age("18 to 25") do
    products_by_users_age(year(25), year(18))
  end

  def products_by_user_age("25 to 35") do
    products_by_users_age(year(35), year(25))
  end

  def products_by_user_age("35 and up") do
    products_by_users_age(0, year(35))
  end

  def products_by_users_age(birth_year_min, birth_year_max) do
    from p in Product,
      join: r in assoc(p, :ratings),
      left_join: u in assoc(r, :user),
      left_join: d in Pento.Survey.Demographic,
      on: d.user_id == u.id,
      where:
        d.year_of_birth >= ^birth_year_min and
          d.year_of_birth <= ^birth_year_max,
      group_by: p.id,
      select: {p.name, fragment("?::float", avg(r.stars))}
  end

  defp year(period) do
    DateTime.utc_now().year - period
  end
end
