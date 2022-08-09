defmodule PentoWeb.QuestionLive.Index do
  use PentoWeb, :live_view

  alias Pento.FAQ
  alias Pento.FAQ.Question

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, questions: get_questions(0), page: 0)
    {:ok, socket, temporary_assigns: [questions: []]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Question")
    |> assign(:question, FAQ.get_question!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Question")
    |> assign(:question, %Question{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Questions")
    |> assign(:question, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    question = FAQ.get_question!(id)
    {:ok, _} = FAQ.delete_question(question)

    {:noreply, assign(socket, :questions, list_questions())}
  end

  @impl true
  def handle_event("load-more", _params, socket) do
    page = socket.assigns.page + 1
    new_questions = get_questions(page)
    questions = socket.assigns.questions ++ new_questions
    socket = assign(socket, questions: questions, page: page)
    {:noreply, socket}
  end

  defp list_questions do
    FAQ.list_questions()
  end

  defp get_questions(page) do
    FAQ.get_questions(page)
  end
end
