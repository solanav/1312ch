defmodule Acab.Channel.Reply do
  use Ecto.Schema
  import Ecto.Changeset

  schema "replies" do
    field :author, :string, default: "Anon"
    field :body, :string
    field :thread_id, :id

    timestamps()
  end

  def parse_reply(reply) do
    %{reply | body: String.split(reply.body, "\n")
    |> Enum.map(fn line ->
      case {String.at(line, 0), String.at(line, 1)} do
        {">", ">"} -> {:response, line}
        {">", _} -> {:green_text, line}
        _ -> {:nothing, line}
      end
    end)}
  end

  @doc false
  def changeset(reply, attrs) do
    reply
    |> cast(attrs, [:author, :body, :thread_id])
    |> validate_required([:body, :thread_id])
  end
end
