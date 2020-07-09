defmodule Acab.Channel.Thread do
  use Ecto.Schema
  import Ecto.Changeset

  schema "threads" do
    field :author, :string
    field :body, :string
    field :title, :string
    field :board_id, :id

    timestamps()
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:author, :title, :body])
    |> validate_required([:author, :title, :body])
  end
end
