defmodule Redezvous.EventsGuests do
  use Ecto.Schema
  import Ecto.Changeset
  alias Redezvous.Models.{Event, User}

  @moduledoc """
  Documentation for EventsGuests.
  """
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "events_guests" do
    belongs_to :user, User
    belongs_to :event, Event
  end

  def changeset(event_guest, attrs) do
    event_guest
    |> cast(attrs, [:user_id, :event_id])
    |> validate_required([:user_id, :event_id])
  end
end
