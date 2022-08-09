defmodule PentoWeb.Live.QuestionLive.Row do
  use PentoWeb, :live_component

  alias Pento.FAQ

  @impl true
  def handle_event("upvote", %{"id" => id}, socket), do: handle_update_vote(id, :inc, socket)
  @impl true
  def handle_event("downvote", %{"id" => id}, socket), do: handle_update_vote(id, :dec, socket)

  defp handle_update_vote(id, type, socket) do
    question = FAQ.get_question!(id)
    FAQ.update_question_vote(question, type)
    {:noreply, assign(socket, :question, FAQ.get_question!(id))}
  end
end
