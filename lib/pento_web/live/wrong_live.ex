defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "Make a guess: ", time: time(), answer: rand(), win: false)}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    time = time()
    {message, score, win} = if (elem(Integer.parse(guess),0) == socket.assigns.answer) do
      {"Your guess: #{guess}. Correct! ",
        socket.assigns.score + 1,
        true
      }
      
    else
      {"Your guess: #{guess}. Wrong. Guess again. ",
        socket.assigns.score - 1,
        false
      }
    end
    {
      :noreply,
      assign(
        socket,
        win: win,
        time: time,
        message: message,
        score: score)}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    <br>
      It's <%= @time %>
    </h2>

    <h2>
    <%= if assigns.win do %> 
      <.link patch={~p"/guess"}>Replay?</.link>
    <% else %>
      <%= for n <- 1..10 do%>
        <.link href="#" phx-click="guess" phx-value-number= {n} >
          <%= n%>
        </.link>
      <% end %>
    <% end %>
    </h2>

    """
  end

  def time() do
    DateTime.utc_now |> to_string
  end

  def rand() do
    :rand.uniform(10)
  end

def handle_params(_params, _session, socket) do
      {:noreply, assign(socket, score: 0, message: "Make a guess: ", time: time(), answer: rand(), win: false)}
  end
end
