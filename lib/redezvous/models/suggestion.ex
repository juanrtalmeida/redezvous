defmodule Redezvous.Models.Suggestion do
  use Ecto.Schema
  alias Redezvous.Models.{User, Event}

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
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "suggestions" do
    field :name, :string
    field :description, :string
    field :location, :string
    field :date, :utc_datetime, default: nil
    belongs_to :event, Event
    belongs_to :user, User

    timestamps()
  end
end
