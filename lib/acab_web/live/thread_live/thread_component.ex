defmodule AcabWeb.ThreadLive.ThreadComponent do
  use AcabWeb, :live_component

  alias Acab.Channel

  @impl true
  def update(assigns, socket) do
    board = assigns[:board]
    thread = assigns[:thread]
    lim = assigns[:lim]

    # Get the last five replies of our thread
    replies = case lim do
      :smol -> Enum.take(Channel.get_replies(thread.id), -5)
      _ -> Channel.get_replies(thread.id)
    end

    {:ok, socket
    |> assign(:thread, thread)
    |> assign(:board, board)
    |> assign(:replies, replies)}
  end
end