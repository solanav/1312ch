defmodule AcabWeb.ReplyLive.Index do
  use AcabWeb, :live_view

  alias Acab.Channel
  alias Acab.Channel.Reply

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :replies, list_replies())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Reply")
    |> assign(:reply, Channel.get_reply!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Reply")
    |> assign(:reply, %Reply{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Replies")
    |> assign(:reply, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    reply = Channel.get_reply!(id)
    {:ok, _} = Channel.delete_reply(reply)

    {:noreply, assign(socket, :replies, list_replies())}
  end

  defp list_replies do
    Channel.list_replies()
  end
end
