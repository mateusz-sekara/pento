defmodule Pento.FAQ.Question do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pento.FAQ.Question

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

  def update_question_vote_changeset(%Question{} = question, :inc), do: update_vote(question, +1)
  def update_question_vote_changeset(%Question{} = question, :dec), do: update_vote(question, -1)

  defp update_vote(%Question{votes: votes} = question, count) do
    attrs = %{votes: votes + count}
    question
    |> cast(attrs, [:votes])
  end
end
