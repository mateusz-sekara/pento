defmodule Pento.FAQ.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :answer, :string
    field :question, :string
    field :votes, :integer

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:question, :answer, :votes])
    |> validate_required([:question, :answer, :votes])
  end
end
