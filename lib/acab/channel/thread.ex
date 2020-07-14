defmodule Acab.Channel.Thread do
  use Ecto.Schema
  import Ecto.Changeset
  alias Acab.Repo

  schema "threads" do
    field :author, :string, default: "Anon"
    field :body, :string
    field :title, :string
    field :board_id, :id

    timestamps()
  end

  def parse_thread(thread) do
    %{thread | body: String.split(thread.body, "\n")
    |> Enum.map(fn line ->
      case {String.at(line, 0), String.at(line, 1)} do
        {">", ">"} -> {:response, line}
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
