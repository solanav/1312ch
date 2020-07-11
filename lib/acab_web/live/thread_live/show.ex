defmodule AcabWeb.ThreadLive.Show do
  use AcabWeb, :live_view

  alias Acab.Channel

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"board_url" => board_url, "thread_id" => id}) do
    thread = Channel.get_thread!(id)
    
    board = Enum.filter(Channel.list_boards(), fn b ->
      b.url == board_url
    end)
    |> Enum.at(0)

    replies = Enum.filter(Channel.list_replies(), fn t ->
      case t.thread_id do
        nil -> False
        _ -> Integer.to_string(t.thread_id) == id
      end
    end)

    socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:replies, replies)
    |> assign(:thread, thread)
    |> assign(:board, board)
  end

  defp page_title(:show), do: "Show Thread"
  defp page_title(:edit), do: "Edit Thread"
  defp page_title(:new_reply), do: "New reply"
end
