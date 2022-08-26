defmodule PentoWeb.Admin.GenderFilter do
  @gender_filter ["all"] ++ ["male", "female", "other", "prefer no to say"]

  def options do
    @gender_filter
  end

  def filter_value(key) do
    if key == default_option() do nil else key end
  end

  def default_option, do: "all"
end
