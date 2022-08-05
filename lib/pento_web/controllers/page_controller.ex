defmodule PentoWeb.PageController do
  use PentoWeb, :controller
  alias PentoWeb.Router

  def index(conn, _params) do
    redirect(conn, to: Router.Helpers.wrong_path(conn, :index))
  end
end
