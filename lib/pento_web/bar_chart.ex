defmodule PentoWeb.BarChart do
  alias Contex.{Dataset, BarChart, Plot}

  def make_chart(%{
        data: data,
        title: title,
        subtitle: subtitle,
        x_label: x_label,
        y_label: y_label
      }) do
    data
    |> Dataset.new()
    |> Plot.new(BarChart, 500, 400)
    |> Plot.titles(title, subtitle)
    |> Plot.axis_labels(x_label, y_label)
    |> Plot.to_svg()
  end
end
