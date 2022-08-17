defmodule PentoWeb.DemographicLive.Form do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Demographic

  @impl true
  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)
      |> assign_demographic()
      |> assign_changeset()
    }
  end

  def assign_demographic(%{assigns: %{current_user: current_user}}= socket) do
    assign(socket, :demographic, %Demographic{user_id: current_user.id})
  end

  def assign_changeset(%{assigns: %{demographic: demographic}}= socket) do
    assign(socket, :changeset, Survey.change_demographic(demographic))
  end

  @impl true
  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    {:noreply, socket |> save_demographic(demographic_params)}
  end

  def save_demographic(socket, demographic_params) do
    case Survey.create_demographic(demographic_params) do
      {:ok, demographic} ->
        send(self(), {:created_demographic, demographic})
        socket
      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: changeset)
    end
  end
end
