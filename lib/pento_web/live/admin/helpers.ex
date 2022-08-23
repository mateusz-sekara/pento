defmodule PentoWeb.Admin.Helpers do
  def year(period) do
    DateTime.utc_now().year - period
  end
end
