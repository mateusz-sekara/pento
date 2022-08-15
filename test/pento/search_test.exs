defmodule Pento.SearchTest do
  use ExUnit.Case

  alias Pento.Catalog.Search

  describe "search" do

    test "changeset/2 should pass for valid attributes" do
      changeset = Search.changeset(%Search{}, %{term: 1234567})
      assert changeset.valid?
    end

    test "changeset/2 should fail for too low digits" do
      changeset = Search.changeset(%Search{}, %{term: 900})
      refute changeset.valid?
      assert pick_first_error_message(changeset) == "Query has to be at least 7 digits"
    end

    test "changeset/2 should fail for too many digits sku" do
      changeset = Search.changeset(%Search{}, %{term: 99999999999})
      refute changeset.valid?
      assert pick_first_error_message(changeset) == "Query has to be at most 7 digits"
    end
  end

  defp pick_first_error_message(changeset) do
    changeset.errors
    |> hd()
    |> Kernel.elem(1)
    |> Kernel.elem(0)
  end
end
