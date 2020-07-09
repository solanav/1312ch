defmodule Acab.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :title, :string
      add :url, :string

      timestamps()
    end

  end
end
