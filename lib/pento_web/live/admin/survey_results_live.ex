defmodule PentoWeb.Admin.SurveyResultsLive do
  use PentoWeb, :live_component
  alias Pento.Catalog
  alias Contex.Dataset
  alias Contex.Plot

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_age_group_filter()
      |> assign_products()
      |> assign_chart()
    }
  end

  defp assign_products(%{assigns: %{age_group_filter: age_group_filter}} = socket) do
    assign(
      socket,
      :products_with_average_ratings,
      Catalog.products_with_average_ratings(%{age_group_filter: age_group_filter})
    )
  end

  def assign_chart(%{assigns: %{products_with_average_ratings: products}} = socket) do
    chart =
      products
      |> Dataset.new()
      |> Plot.new(Contex.BarChart, 500, 400)
      |> Plot.titles("Product Ratings", "average star ratings per product")
      |> Plot.axis_labels("products", "start")
      |> Plot.to_svg()

    assign(socket, :chart, chart)
  end

  defp assign_age_group_filter(socket) do
    assign_age_group_filter(socket, "all")
  end

  defp assign_age_group_filter(socket, age_group_filter) do
    assign(socket, :age_group_filter, age_group_filter)
  end

  @impl true
  def handle_event(
    "age_group_filter",
    %{"age_group_filter" => age_group_filter},
    socket
  ) do
    {
      :noreply,
      socket
      |> assign_age_group_filter(age_group_filter)
      |> assign_products()
      |> assign_chart()
    }
  end
end
