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

  def handle_info(:tick, socket = %{assigns: %{up: true}}) do
    {:noreply, adjust(socket, &Kernel.+/2)}
  end

  def handle_info(:tick, socket = %{assigns: %{up: false}}) do
    {:noreply, adjust(socket, &Kernel.-/2)}
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

  def handle_event("delete", params, socket) do
    {:noreply, delete(socket, params)}
  end

  def handle_event("boom", _, socket) do
    _ = 1 / 0
    {:noreply, socket}
  end

  defp adjust(socket = %{assigns: %{counters: counters}}, operator) do
    counters =
      counters
      |> Enum.map(fn counter ->
        %{counter | count: operator.(counter.count, 1)}
      end)

    assign(socket, counters: counters)
  end

  defp validate(socket, params) do
    changeset = CounterFormData.changeset(%CounterFormData{}, params)
    assign(socket, changeset: changeset)
  end

  defp save(socket, %{"name" => name, "count" => count}) do
    assign(socket,
      counters: [
        %CounterFormData{name: name, count: String.to_integer(count)} | socket.assigns.counters
      ]
    )
  end

  defp delete(socket, %{"counter-name" => counter_name}) do
    assign(socket,
      counters: Enum.reject(socket.assigns.counters, fn item -> item.name == counter_name end)
    )
  end
end
