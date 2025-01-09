defmodule Redezvous.Models.Event do
  use Ecto.Schema
  alias Redezvous.Models.User
  import Ecto.Changeset

  @moduledoc """
  Documentation for Event.
  """

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @type t :: %__MODULE__{
          id: binary(),
          title: String.t(),
          description: String.t(),
          date: DateTime.t(),
          location: String.t(),
          finished: boolean(),
          cancelled: boolean(),
          created_by: User.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "events" do
    field :title, :string
    field :description, :string
    field :date, :utc_datetime, default: nil
    field :location, :string, default: nil
    field :finished, :boolean, default: false
    field :cancelled, :boolean, default: false

    belongs_to :created_by, User, foreign_key: :created_by_id
    many_to_many :guests, User, join_through: "events_guests", join_keys: [event_id: :id, user_id: :id]
    timestamps()
  end

  def changeset(event \\ %__MODULE__{}, params) do
    event
    |> cast(params, [:title, :description, :date, :location, :finished, :cancelled])
    |> validate_required([:title, :description])
    |> validate_required([:title, :description])
    |> put_assoc(:created_by, params.created_by)
    |> put_assoc(:guests, params.guests)
  end
end
