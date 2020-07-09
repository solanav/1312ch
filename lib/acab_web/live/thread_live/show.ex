defmodule AcabWeb.ThreadLive.Show do
  use AcabWeb, :live_view

  alias Acab.Channel

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    thread = Channel.get_thread!(id)
    board = Channel.get_board!(thread.board_id)
    
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:thread, thread)
     |> assign(:board, board)}
  end

  defp page_title(:show), do: "Show Thread"
  defp page_title(:edit), do: "Edit Thread"
end
