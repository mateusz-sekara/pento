defmodule Pento.Catalog.Product.Query do
  import Ecto.Query

  alias Pento.Catalog.Product
  alias Pento.Survey.{Rating, Demographic}

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

  def products_with_average_rating(filters) do

    aggregations_query =
      from p in Product,
        join: r in assoc(p, :ratings),
        left_join: u in assoc(r, :user),
        left_join: d in Demographic,
        on: d.user_id == u.id,
        group_by: p.id,
        select: %{id: p.id, avg_rating: fragment("?::float", avg(r.stars))}

    aggregations_query =
      aggregations_query
      |> with_year_of_birth(Map.get(filters, :age_filter))
      |> with_gender(Map.get(filters, :gender_filter))

    from p in Product,
      left_join: aggr in subquery(aggregations_query),
      on: p.id == aggr.id,
      select: [p.name, coalesce(aggr.avg_rating, 0)]
  end

  def with_year_of_birth(query, %{min: min, max: max}) do
    query
    |> where([_, _, _, d], d.year_of_birth >= ^min and d.year_of_birth <= ^max)
  end

  def with_year_of_birth(query, %{min: min}) do
    with_year_of_birth(query, %{min: min, max: max_year_of_birth()})
  end

  def with_year_of_birth(query, %{max: max}) do
    with_year_of_birth(query, %{min: min_year_of_birth(), max: max})
  end

  def with_year_of_birth(query, nil) do
    query
  end

  def with_gender(query, nil) do
    query
  end

  def with_gender(query, gender_filter) do
    query
    |> where([_, _, _, d], d.gender == ^gender_filter)
  end

  defp min_year_of_birth do
    first.._last = Demographic.year_of_birth_range()
    first
  end

  defp max_year_of_birth do
    _first..last = Demographic.year_of_birth_range()
    last
  end
end
