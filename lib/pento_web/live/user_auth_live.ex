defmodule PentoWeb.UserAuthLive do
  import Phoenix.LiveView
  alias Pento.Accounts

  def on_mount(_, _params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)
    socket =
      socket
      |> assign(:current_user, user)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/users/log_in")}
    end
  end

  def on_mount(_, _, _, socket) do
    {:halt, redirect(socket, to: "/users/log_in")}
  end
end
