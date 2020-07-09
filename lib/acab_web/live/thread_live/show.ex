defmodule AcabWeb.ThreadLive.Show do
  use AcabWeb, :live_view

  alias Acab.Channel
  alias Acab.Channel.Board

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, thi, socket) do
    thread = Channel.get_thread!(id)
    IO.inspect thi
    
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:thread, thread)
     |> assign(:board, %Board{url: "m", title: "general"})}
  end

  defp page_title(:show), do: "Show Thread"
  defp page_title(:edit), do: "Edit Thread"
end
