defmodule Redezvous.Repo.Migrations.CreateVotesTable do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :value, :boolean
      add :user_id, references(:users)
      add :suggestion_id, references(:suggestions)

      timestamps()
    end
  end
end
