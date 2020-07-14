defmodule Acab.Channel.Board do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boards" do
    field :title, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:title, :url])
    |> validate_required([:url])
  end

  @doc false
  def update_time(board) do
    updated_at = DateTime.utc_now
    |> DateTime.to_iso8601

    IO.puts updated_at
    IO.puts updated_at
    IO.puts updated_at
    IO.puts updated_at

    board
    |> cast(%{updated_at: updated_at}, [:updated_at])
  end
end
