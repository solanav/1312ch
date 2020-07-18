defmodule AcabWeb.ReplyLive.FormComponent do
  use AcabWeb, :live_component

  alias Acab.Channel
  alias Acab.Repo

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

  defp save_reply(socket, :new, reply_params) do
    # Check if there can be more replies
    max_replies = Application.get_env(:acab, AcabWeb.Endpoint)[:max_replies]
    nreplies = Channel.count_replies(String.to_integer(reply_params["thread_id"]))

    # Check if captcha is correct
    img_solution = Acab.Session.get(socket.id())

    if nreplies < max_replies and reply_params["captcha"] == img_solution do
      # Remove captcha from ets
      Acab.Session.delete(socket.id())
      
      case Channel.create_reply(reply_params) do
        {:ok, _reply} ->
          {:noreply, push_redirect(socket, to: socket.assigns.return_to)}
          
        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, changeset: changeset)}
      end
    else
      {:noreply, push_redirect(socket, to: socket.assigns.return_to)}
    end
  end
end
