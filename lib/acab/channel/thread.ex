defmodule Acab.Channel.Thread do
  use Ecto.Schema
  import Ecto.Changeset

  schema "threads" do
    field :author, :string, default: "Anon"
    field :body, :string
    field :title, :string
    field :board_id, :id

    timestamps()
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:author, :title, :body, :board_id])
    |> validate_required([:author, :title, :body, :board_id])
  end
end
