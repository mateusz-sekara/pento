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
      |> assign_products_with_average_ratings()
      |> assign_dataset()
      |> assign_chart()
      |> assign_chart_svg()
    }
  end

  def assign_products_with_average_ratings(socket) do
    socket
    |> assign(:products_with_average_ratings, Catalog.products_with_average_ratings())
  end

  def assign_dataset(
    %{
      assigns: %{
        products_with_average_ratings: products_with_average_ratings
      }
    } = socket
  ) do
    socket
    |> assign(:dataset, make_bar_chart_dataset(products_with_average_ratings))
  end

  def assign_chart(%{assigns: %{dataset: dataset}} = socket) do
    socket
    |> assign(:chart, make_bar_chart(dataset))
  end

  def assign_chart_svg(%{assigns: %{chart: chart}} = socket) do
    socket
    |> assign(:chart_svg, render_bar_chart(chart))
  end

  def make_bar_chart_dataset(data) do
    Dataset.new(data)
  end

  def make_bar_chart(dataset) do
    Contex.BarChart.new(dataset)
  end

  def render_bar_chart(chart) do
    Plot.new(500, 400, chart)
    |> Plot.titles("Product Ratings", "average star ratings per product")
    |> Plot.axis_labels("products", "start")
    |> Plot.to_svg()
  end
end
