defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "Make guess", goal: goal(), time: time())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
      It's <%= @time %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number={n}><%= n %></a>
      <% end %>
    </h2>
    """
  end

  @impl true
  def handle_event("guess", %{"number" => guess}, socket) do
    {guess, _} = Integer.parse(guess)
    {message, point} = cond do
      guess == socket.assigns.goal ->
        win_props(guess)
      true ->
        loose_props(guess, socket.assigns.goal)
    end

    score = socket.assigns.score + point

    {
      :noreply,
      assign(socket, message: message, score: score, goal: goal(), time: time())
    }
  end

  def win_props(guess) do
    {
      "Your guess: #{guess}. You win", 1
    }
  end

  def loose_props(guess, goal) do
    {
      "Your guess: #{guess}. Wrong. Guess again. #{goal}", -1
    }
  end

  def time() do
    DateTime.utc_now() |> to_string
  end

  def goal() do
    :rand.uniform(10)
  end
end
