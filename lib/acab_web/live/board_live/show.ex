defmodule AcabWeb.BoardLive.Show do
  use AcabWeb, :live_view

  alias Acab.Channel
  alias Acab.Channel.Board
  alias Acab.Channel.Thread

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Channel.subscribe()
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

    # Save image text on ets
    {:ok, text, img_binary} = Captcha.get()
    Acab.Session.put(socket.id(), text)

    apply_action(socket, :show, %{"board_url" => board_url})
    |> assign(:thread, %Thread{})
    |> assign(:captcha, Base.encode64(img_binary))
  end

  @impl true
  def handle_info({:thread_created, thread}, socket) do
    {:noreply, update(socket, :threads, fn threads -> [thread | threads] end)}
  end

  @impl true
  def handle_info({:reply_created, reply}, socket) do
    {:noreply, update(socket, :threads, fn threads ->
      threads = Enum.map(threads, fn {t, r} ->
        if t.id == reply.thread_id do
          thread = Channel.get_thread!(reply.thread_id)
          replies = Channel.get_replies(thread.id)
          |> Enum.take(-5)
          
          {thread, replies}
        else
          {t, r}
        end
      end)
    end)}
  end

  defp page_title(:show), do: "Show Board"
  defp page_title(:new), do: "New thread"
end
