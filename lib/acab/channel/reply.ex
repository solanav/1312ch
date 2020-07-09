defmodule Acab.Channel.Reply do
  use Ecto.Schema
  import Ecto.Changeset

  schema "replies" do
    field :author, :string, default: "Anon"
    field :body, :string
    field :thread_id, :id

    timestamps()
  end

  @doc false
  def changeset(reply, attrs) do
    reply
    |> cast(attrs, [:author, :body, :thread_id])
    |> validate_required([:body, :thread_id])
  end
end
