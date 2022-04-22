defmodule CountersWeb.Live.ReactionCounter do
  use CountersWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="my-4">
      <h3 class="text-lg">
        <span class="text-2xl"><%= @emoji %></span><%= render_slot(@inner_block) %>
      </h3>
      <div>
        <button
          class="bg-accent p-2 w-20 text-accent-foreground font-bold rounded-lg"
          phx-click="inc"
          phx-target={@myself}
        >
          🤩 <%= @count %>
        </button> Write took <%= @write_time |> us_to_ms %> ms, avg:
        <%= @write_time_history |> get_avg_write_time |> us_to_ms %> ms
      </div>
    </div>
    """
  end

  defp get_avg_write_time([]), do: 0

  defp get_avg_write_time(write_time_history) do
    round(Enum.sum(write_time_history) / length(write_time_history))
  end

  defp us_to_ms(number) when is_number(number) do
    Float.round(number / 1000, 2)
  end

  def mount(socket) do
    socket =
      socket
      |> assign(:count, 0)
      |> assign(:write_time, 0)
      |> assign(:write_time_history, [])

    {:ok, socket}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(:count, Counters.Reactions.get_reaction_count!(assigns.id))

    {:ok, socket}
  end

  def handle_event("inc", _, socket) do
    {time, count} =
      :timer.tc(&Counters.Reactions.increment_reaction_count!/1, [socket.assigns.id])

    socket =
      socket
      |> assign(:count, count)
      |> assign(:write_time, time)
      |> update(:write_time_history, &[time | &1])

    {:noreply, socket}
  end
end