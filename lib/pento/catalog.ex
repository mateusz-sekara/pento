defmodule Pento.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias Pento.Repo

  alias Pento.Catalog.Search
  alias Pento.Catalog.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  def list_products_with_user_ratings(user) do
    Product.Query.with_user_ratings(user)
    |> Repo.all()
  end

  def products_with_average_ratings do
    Product.Query.with_average_ratings()
    |> Repo.all()
  end

  def products_with_average_ratings(
    %{age_group_filter: age_group_filter}
  ) do
    Product.Query.products_with_average_ratings_by_age(age_group_filter)
    |> Repo.all()
  end

  def search_product_by_sku(attrs) do
    changeset = %Search{}
    |> Search.changeset(attrs)

    case changeset.valid? do
      true ->
        changeset.changes
        |> Map.get(:term)
        |> search_by_sku()
      false -> nil
    end
  end

  defp search_by_sku(sku) do
    query =
      from p in Product,
        where: p.sku == ^sku
    Repo.one(query)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  def markdown_product(%Product{unit_price: unit_price} = product, amount) do
    Product.price_decrease_changeset(product, %{unit_price: unit_price - amount})
    |> Repo.update()
  end
end
