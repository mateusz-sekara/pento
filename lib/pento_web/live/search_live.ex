defmodule PentoWeb.SearchLive do
  use PentoWeb, :live_view
  alias Pento.Catalog.Search
  alias Pento.Catalog

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:changeset, Search.changeset(%Search{}))
      |> assign(:result, nil)
    {:ok, socket}
  end

  @impl true
  def handle_event(
    "validate",
    %{"search" => search_params},
    socket
  ) do
    changeset =
      %Search{}
      |> Search.changeset(search_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event(
    "search",
    %{"search" => search_params},
    socket
  ) do
    result = Catalog.search_product_by_sku(search_params)
    {
      :noreply,
      assign(socket, :result, result)
    }
  end

  @impl true
  def render(%{changeset: changeset, result: result} = assigns) do
    ~H"""
    <div>
      <.form
        let={f}
        for={changeset}
        id="search-form"
        phx-change="validate"
        phx-submit="search">

        <%= label f, :term %>
        <%= text_input f, :term %>
        <%= error_tag f, :term %>
     </.form>

     <div>
        <%= inspect(result) %>
     </div>
    </div>
    """
  end
end
