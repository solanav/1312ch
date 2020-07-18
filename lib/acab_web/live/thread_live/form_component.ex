defmodule AcabWeb.ThreadLive.FormComponent do
  use AcabWeb, :live_component

  alias Acab.Channel

  @impl true
  def update(%{thread: thread} = assigns, socket) do
    changeset = Channel.change_thread(thread)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"thread" => thread_params}, socket) do
    changeset =
      socket.assigns.thread
      |> Channel.change_thread(thread_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"thread" => thread_params}, socket) do
    save_thread(socket, socket.assigns.action, thread_params)
  end

  defp save_thread(socket, :new, thread_params) do
    img_solution = Acab.Session.get(socket.id())

    if thread_params["captcha"] == img_solution do
      # Remove captcha from ets
      Acab.Session.delete(socket.id())
      
      case Channel.create_thread(thread_params) do
        {:ok, _thread} ->
          Channel.delete_old_threads()
          {:noreply, push_redirect(socket, to: socket.assigns.return_to)}
          
        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, changeset: changeset)}
      end
    else
      {:noreply,push_redirect(socket, to: socket.assigns.return_to)}
    end
  end
end
