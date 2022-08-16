defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias PentoWeb.DemographicLive
  alias Pento.Survey

  def mount(_params, _session, socket) do
    {:ok, socket |> assign_demographic}
  end

  def assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    IO.inspect(current_user)
    assign(socket, :demographic, Survey.get_demographic_by_user(current_user))
  end
end
