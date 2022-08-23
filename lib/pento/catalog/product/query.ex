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

  def products_with_average_rating(%{min: min, max: max} = _age_filter) do
    aggregations_query = from p in Product,
      join: r in assoc(p, :ratings),
      left_join: u in assoc(r, :user),
      left_join: d in Demographic, on: d.user_id == u.id,
      where: d.year_of_birth >= ^min and d.year_of_birth <= ^max,
      group_by: p.id,
      select: %{id: p.id, avg_rating: fragment("?::float", avg(r.stars))}

    from p in Product,
      left_join: aggr in subquery(aggregations_query), on: p.id == aggr.id,
      select: [p.name, coalesce(aggr.avg_rating, 0)]
  end
  def products_with_average_rating(%{min: min}) do
    products_with_average_rating(%{min: min, max: DateTime.utc_now().year})
  end
  def products_with_average_rating(%{max: max}) do
    products_with_average_rating(%{min: 1900, max: max})
  end
  def products_with_average_rating(%{}) do
    products_with_average_rating(%{min: 1900, max: DateTime.utc_now().year})
  end
end
