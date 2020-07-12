defmodule AcabWeb.ReplyLive.ReplyComponent do
  use AcabWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok, socket
    |> assign(:reply, assigns[:reply])}
  end
end