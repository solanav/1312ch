defmodule AcabWeb.ReplyLive.FormComponent do
  use AcabWeb, :live_component

  alias Acab.Channel

  @impl true
  def update(%{reply: reply} = assigns, socket) do
    changeset = Channel.change_reply(reply)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"reply" => reply_params}, socket) do
    changeset =
      socket.assigns.reply
      |> Channel.change_reply(reply_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"reply" => reply_params}, socket) do
    save_reply(socket, socket.assigns.action, reply_params)
  end

  defp save_reply(socket, :edit, reply_params) do
    case Channel.update_reply(socket.assigns.reply, reply_params) do
      {:ok, _reply} ->
        {:noreply,
         socket
         |> put_flash(:info, "Reply updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_reply(socket, :new, reply_params) do
    case Channel.create_reply(reply_params) do
      {:ok, _reply} ->
        {:noreply,
         socket
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
