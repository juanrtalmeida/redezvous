defmodule Redezvous.Repo.Migrations.CreateEventTable do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :description, :string
      add :created_by, references(:users)
      add :date, :utc_datetime, default: nil
      add :location, :string, default: nil
      add :finished, :boolean, default: false
      add :cancelled, :boolean, default: false

      timestamps()
    end
  end
end
