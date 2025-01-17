defmodule Redezvous.Models.Suggestion do
  alias Redezvous.Models.{Event, User, Vote}
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Documentation for Suggestion.
  """

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @type t :: %__MODULE__{
          id: binary(),
          name: String.t(),
          description: String.t(),
          location: String.t(),
          date: DateTime.t(),
          event: Event.t(),
          user: User.t(),
          event: Event.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t(),
          votes: [Vote.t()]
        }

  schema "suggestions" do
    field :name, :string
    field :description, :string
    field :location, :string
    field :date, :utc_datetime, default: nil
    belongs_to :event, Event
    belongs_to :user, User
    has_many :votes, Vote

    timestamps()
  end

  def changeset(suggestion \\ %__MODULE__{}, atts) do
    suggestion
    |> cast(atts, [:name, :description, :location, :date])
    |> validate_required([:name, :description])
    |> put_assoc(:user, atts.created_by)
    |> put_assoc(:event, atts.event)
  end
end
