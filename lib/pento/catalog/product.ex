defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pento.Catalog.Product

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :float

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0.0)
  end

  def price_decrease_changeset(
    %Product{unit_price: current_unit_price} = product,
    attrs
  ) do
    product
    |> cast(attrs, [:unit_price])
    |> validate_change(:unit_price, fn :unit_price, new_unit_price ->
      if new_unit_price >= current_unit_price do
        [unit_price: "New price must be lower than the current one - because reasons."]
      else
        []
      end
    end)
  end
end
