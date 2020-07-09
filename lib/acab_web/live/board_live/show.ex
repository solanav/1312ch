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

  defp apply_action(socket, :show, %{"id" => id}) do
    threads = Enum.filter(Channel.list_threads(), fn t ->
      case t.board_id do
        nil -> False
        _ -> Integer.to_string(t.board_id) == id
      end
    end)

    socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:board, Channel.get_board!(id))
    |> assign(:replies, [])
    |> assign(:threads, threads)
  end

  defp apply_action(socket, :new_thread, %{"id" => id}) do
    threads = Enum.filter(Channel.list_threads(), fn t ->
      case t.board_id do
        nil -> False
        _ -> Integer.to_string(t.board_id) == id
      end
    end)

    socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:board, Channel.get_board!(id))
    |> assign(:replies, [])
    |> assign(:threads, threads)
    |> assign(:thread, %Thread{})
  end

  defp page_title(:show), do: "Show Board"
  defp page_title(:edit), do: "Edit Board"
  defp page_title(:new_thread), do: "New thread"
end
