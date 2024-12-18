defmodule Redezvous.Repo.Migrations.CreateSuggestionTable do
  use Ecto.Migration

  def change do
    create table(:suggestions) do
      add :name, :string
      add :description, :string
      add :location, :string
      add :date, :utc_datetime, default: nil
      add :event_id, references(:events)
      add :user_id, references(:users)

      timestamps()
    end
  end
end
