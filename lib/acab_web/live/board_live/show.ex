defmodule AcabWeb.BoardLive.Show do
  use AcabWeb, :live_view

  alias Acab.Channel

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    threads = Enum.filter(Channel.list_threads(), fn t ->
      Integer.to_string(t.board_id) == id
    end)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:board, Channel.get_board!(id))
     |> assign(:replies, [])
     |> assign(:threads, threads)}
  end

  defp page_title(:show), do: "Show Board"
  defp page_title(:edit), do: "Edit Board"
end
