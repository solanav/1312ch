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

  defp apply_action(socket, :show, %{"board_url" => url}) do
    board = Channel.get_board(url)
    threads = Channel.get_threads(board.id)

    socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:board, board)
    |> assign(:replies, [])
    |> assign(:threads, threads)
  end

  defp apply_action(socket, :new, %{"board_url" => url}) do
    board = Channel.get_board(url)
    threads = Channel.get_threads(board.id)

    socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:board, board)
    |> assign(:replies, [])
    |> assign(:threads, threads)
    |> assign(:thread, %Thread{})
  end

  defp page_title(:show), do: "Show Board"
  defp page_title(:new), do: "New thread"
end
