defmodule AcabWeb.BoardLive.Show do
  use AcabWeb, :live_view

  alias Acab.Channel
  alias Acab.Channel.Thread

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, __url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"board_url" => board_url}) do
    board = Channel.get_board(board_url)
    threads = Enum.map(Channel.get_threads(board.id), fn t ->
      replies = Enum.take(Channel.get_replies(t.id), -5)
      {t, replies}
    end)

    socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:board, board)
    |> assign(:threads, threads)
  end

  defp apply_action(socket, :new, %{"board_url" => board_url}) do
    Board.update_time(Channel.get_board(board_url))

    apply_action(socket, :show, %{"board_url" => board_url})
    |> assign(:thread, %Thread{})
  end

  defp page_title(:show), do: "Show Board"
  defp page_title(:new), do: "New thread"
end
