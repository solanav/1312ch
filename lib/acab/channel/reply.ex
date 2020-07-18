defmodule Acab.Channel.Reply do
  use Ecto.Schema
  import Ecto.Changeset
  alias Acab.Channel

  schema "replies" do
    field :author, :string, default: "Anon"
    field :body, :string
    field :thread_id, :id

    timestamps()
  end

  def references_reply?(reply_ref, reply) do
    # Get raw list of replies (on our thread)
    replies = Enum.filter(Channel.list_replies(), fn r ->
      r.thread_id == reply.thread_id
    end)

    # Go through replies to check if we reference one of them
    Enum.reduce(replies, false, fn x, acc ->
      if x.id != reply_ref do
        acc
      else
        true
      end
    end)
  end

  def references_op?(reply_ref, reply) do
    member = (reply_ref == reply.thread_id)
  end

  def check_reference(reply, line) do
    reply_id = line
    |> String.slice(2..-1)
    |> Integer.parse()

    case reply_id do
      {reply_ref, ""} ->
        cond do
          references_op?(reply_ref, reply) -> {:response_op, reply_ref}
          references_reply?(reply_ref, reply) -> {:response, reply_ref}
          true -> {:nothing, line}
        end
      _ -> {:nothing, line} 
    end
  end

  def parse_reply(reply) do
    %{reply | body: String.split(reply.body, "\n")
    |> Enum.map(fn line ->
      case {String.at(line, 0), String.at(line, 1)} do
        {">", ">"} -> check_reference(reply, line)
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
