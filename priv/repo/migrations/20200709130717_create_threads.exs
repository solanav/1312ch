defmodule Acab.Repo.Migrations.CreateThreads do
  use Ecto.Migration

  def change do
    create table(:threads) do
      add :author, :string
      add :title, :string
      add :body, :text
      add :board_id, references(:boards, on_delete: :nothing)

      timestamps()
    end

    create index(:threads, [:board_id])
  end
end
