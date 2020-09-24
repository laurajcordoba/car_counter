defmodule CarCounterWeb.CounterLive do
  use CarCounterWeb, :live_view
  alias CarCounter.CounterFormData

  def mount(_params, _session, socket) do
    changeset =
      CounterFormData.new()
      |> CounterFormData.changeset(%{})

    :timer.send_interval(250, self(), :tick)

    {:ok,
     assign(socket,
       counters: [%CounterFormData{name: "Initial", count: 13}],
       up: true,
       changeset: changeset
     )}
  end

  # def render(assigns) do
  #   ~L"""
  #     <h1>Current Count <%= @count %></h1>
  #     <button phx-click="reverse">Reverse</button>
  #   """
  # end

  def handle_info(:tick, socket = %{assigns: %{up: true}}) do
    {:noreply, inc(socket)}
  end

  def handle_info(:tick, socket = %{assigns: %{up: false}}) do
    {:noreply, dec(socket)}
  end

  def handle_event("reverse", _, socket) do
    {:noreply, assign(socket, :up, !socket.assigns.up)}
  end

  def handle_event("validate", %{"form" => params}, socket) do
    {:noreply, validate(socket, params)}
  end

  def handle_event("save", %{"form" => params}, socket) do
    {:noreply, save(socket, params)}
  end

  def handle_event("boom", _, socket) do
    _ = 1 / 0
    {:noreply, socket}
  end

  defp inc(socket = %{assigns: %{counters: counters}}) do
    counters
    |> Enum.map(fn counter ->
      %{counter | count: counter.count + 1}
    end)

    assign(socket, counters: counters)
  end

  defp dec(socket) do
    assign(socket, count: socket.assigns.count - 1)
  end

  defp validate(socket, params) do
    changeset = CounterFormData.changeset(%CounterFormData{}, params)
    assign(socket, changeset: changeset)
  end

  defp save(socket, params) do
  end
end
