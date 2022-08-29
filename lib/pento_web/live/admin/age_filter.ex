defmodule PentoWeb.Admin.AgeFilter do
  import PentoWeb.Admin.Helpers

  @age_group_filter %{
    "all" => %{order: 1, val: nil},
    "18 and under" => %{order: 2, val: %{min: year(18)}},
    "18 to 25" => %{order: 3, val: %{min: year(25), max: year(15)}},
    "25 to 35" => %{order: 4, val: %{min: year(35), max: year(25)}},
    "35 and up" => %{order: 5, val: %{max: year(35)}}
  }

  def options do
    Map.to_list(@age_group_filter)
    |> Enum.sort_by(fn {_, %{order: order}} -> order end)
    |> Enum.map(fn {key, _} -> key end)
  end

  @spec filter_value(any) :: any
  def filter_value(key) do
    Map.get(@age_group_filter, key)
    |> Map.get(:val)
  end

  def default_option, do: "all"
end
