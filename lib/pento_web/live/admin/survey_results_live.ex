defmodule PentoWeb.Admin.SurveyResultsLive do
  use PentoWeb, :live_chart_component
  alias Pento.Catalog
  alias PentoWeb.Admin.AgeFilter
  alias PentoWeb.Admin.GenderFilter

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_age_group_filter()
      |> assign_gender_filter()
      |> assign_products()
      |> assign_chart()
    }
  end

  def assign_products(%{assigns: assigns} = socket) do

    filters = %{
      age_group_filter: AgeFilter.filter_value(Map.get(assigns, :age_group_filter)),
      gender_filter: GenderFilter.filter_value(Map.get(assigns, :gender_filter))
    }

    assign(
      socket,
      :products_with_average_ratings,
      Catalog.products_with_average_ratings(filters)
    )
  end

  def assign_chart(%{assigns: %{products_with_average_ratings: products}} = socket) do
    chart =
      make_chart(%{
        data: products,
        title: "Product Ratings",
        subtitle: "average star ratings per product",
        x_label: "products",
        y_label: "stars"
      })

    assign(socket, :chart, chart)
  end

  def assign_age_group_filter(
    %{assigns: %{age_group_filter: age_group_filter}} = socket
  ) do
    assign_age_group_filter(socket, age_group_filter)
  end

  def assign_age_group_filter(socket) do
    assign_age_group_filter(socket, AgeFilter.default_option())
  end

  def assign_age_group_filter(socket, age_group_filter) do
    assign(socket, :age_group_filter, age_group_filter)
  end

  def assign_gender_filter(
    %{assigns: %{gender_filter: gender_filter}} = socket
  ) do
    assign_gender_filter(socket, gender_filter)
  end

  def assign_gender_filter(socket) do
    assign_gender_filter(socket, GenderFilter.default_option())
  end

  def assign_gender_filter(socket, gender_filter) do
    assign(socket, :gender_filter, gender_filter)
  end

  @impl true
  def handle_event(
        "update_filters",
        %{
          "age_group_filter" => age_group_filter,
          "gender_filter" => gender_filter
        },
        socket
      ) do
    {
      :noreply,
      socket
      |> assign_age_group_filter(age_group_filter)
      |> assign_gender_filter(gender_filter)
      |> assign_products()
      |> assign_chart()
    }
  end
end
