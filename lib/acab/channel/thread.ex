defmodule Acab.Channel.Thread do
  use Ecto.Schema
  import Ecto.Changeset
  alias Acab.Repo
  alias Acab.Channel

  schema "threads" do
    field :author, :string, default: "Anon"
    field :body, :string
    field :title, :string
    field :board_id, :id

    timestamps()
  end

  def references_thread?(reply_ref, thread) do
    # Get list of threads in this board
    threads = Enum.filter(Channel.list_threads(), fn t ->
      t.board_id == thread.board_id
    end)

    # Go through replies to check if we reference one of them
    Enum.reduce(threads, false, fn t, acc ->
      if t.id != reply_ref do
        acc
      else
        true
      end
    end)
  end

  def check_reference(thread, line) do
    thread_id = line
    |> String.slice(2..-1)
    |> Integer.parse()

    case thread_id do
      {reply_ref, ""} ->
        cond do
          references_thread?(reply_ref, thread) -> {:response, reply_ref}
          true -> {:nothing, line}
        end
      _ -> {:nothing, line} 
    end
  end

  def parse_thread(thread) do
    %{thread | body: String.split(thread.body, "\n")
    |> Enum.map(fn line ->
      case {String.at(line, 0), String.at(line, 1)} do
        {">", ">"} -> check_reference(thread, line)
        {">", _} -> {:green_text, line}
        _ -> {:nothing, line}
      end
    end)}
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:author, :title, :body, :board_id])
    |> validate_required([:body, :board_id])
  end

  @doc false
  def update_time(thread) do
    updated_at = DateTime.utc_now
    |> DateTime.to_iso8601

    thread
    |> cast(%{updated_at: updated_at}, [:updated_at])
    |> Repo.update()
  end
end
