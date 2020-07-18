defmodule AcabWeb.ThreadLive.Show do
  use AcabWeb, :live_view

  alias Acab.Channel
  alias Acab.Channel.Reply
  alias Acab.Channel.Board
  alias Acab.Channel.Thread

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Channel.subscribe()
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"board_url" => board_url, "thread_id" => id}) do
    {id, _} = Integer.parse(id)

    socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:replies, Channel.get_replies(id))
    |> assign(:thread, Channel.get_thread!(id))
    |> assign(:board, Channel.get_board(board_url))
  end

  defp apply_action(socket, :new, %{"board_url" => board_url, "thread_id" => id}) do
    Board.update_time(Channel.get_board(board_url))
    Thread.update_time(Channel.get_thread!(id))

    # Save image text on ets
    {:ok, text, img_binary} = Captcha.get()
    Acab.Session.put(socket.id(), text)

    apply_action(socket, :show, %{"board_url" => board_url, "thread_id" => id})
    |> assign(:reply, %Reply{})
    |> assign(:captcha, Base.encode64(img_binary))
  end

  @impl true
  def handle_info({:reply_created, reply}, socket) do
    {:noreply, update(socket, :replies, fn replies -> replies ++ [reply] end)}
  end

  @impl true
  def handle_info({:thread_created, reply}, socket) do
    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Thread"
  defp page_title(:new), do: "New reply"
end
