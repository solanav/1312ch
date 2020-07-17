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

  def parse_reply(reply) do
    replies = Enum.filter(Channel.list_replies(), fn r ->
      r.thread_id == reply.thread_id
    end)

    %{reply | body: String.split(reply.body, "\n")
    |> Enum.map(fn line ->
      case {String.at(line, 0), String.at(line, 1)} do
        {">", ">"} ->
          reply_id = line
          |> String.slice(2..-1)
          |> Integer.parse()

          case reply_id do
            {i, ""} ->
              IO.puts i
              IO.puts i
              IO.puts i

              member = Enum.reduce(replies, false, fn x, acc ->
                if x.id != i do
                  acc
                else
                  true
                end
              end)

              IO.puts member
              IO.puts member
              IO.puts member
              
              if member do
                {:response, i}
              else
                {:nothing, line}
              end
            _ ->
              {:nothing, line} 
          end
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
