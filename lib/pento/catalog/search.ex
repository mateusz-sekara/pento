defmodule Pento.Catalog.Search do
  defstruct [:term]
  @types %{term: :integer}

  import Ecto.Changeset

  def changeset(%__MODULE__{} = query, attrs \\ %{}) do
    {query, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:term])
    |> validate_number(
      :term,
      greater_than_or_equal_to: 1_000_000,
      message: "Query has to be at least 7 digits"
    )
    |> validate_number(
      :term,
      less_than: 10_000_000,
      message: "Query has to be at most 7 digits"
    )
  end
end
