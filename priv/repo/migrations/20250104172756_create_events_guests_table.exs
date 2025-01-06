defmodule Redezvous.Repo.Migrations.CreateEventsGuestsTable do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:events_guests) do
      add :user_id, references(:users)
      add :event_id, references(:events)

      timestamps()
    end
  end
end
