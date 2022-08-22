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
      |> assign(:chart, render_chart())
    }
  end

  def render_chart() do
    Catalog.products_with_average_ratings()
    |> Dataset.new()
    |> Plot.new(Contex.BarChart, 500, 400)
    |> Plot.titles("Product Ratings", "average star ratings per product")
    |> Plot.axis_labels("products", "start")
    |> Plot.to_svg()
  end
end
