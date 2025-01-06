defmodule Redezvous.Models.User do
  @moduledoc false
  use Ecto.Schema
  alias Redezvous.Models.{Event, Vote, Suggestion}
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:password]}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @type t() :: %__MODULE__{
          id: binary(),
          name: String.t(),
          email: String.t(),
          password: String.t(),
          suggestions: [Suggestion.t()],
          votes: [Vote.t()],
          events: [Event.t()],
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
    has_many :suggestions, Suggestion
    has_many :votes, Vote
    has_many :events, Event, foreign_key: :created_by_id
    many_to_many :guest, Event, join_through: "event_guests"
    timestamps()
  end

  @spec changeset(%__MODULE__{}, map()) :: Ecto.Changeset.t()
  def changeset(struct \\ %__MODULE__{}, attrs) do
    struct
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_length(:name, min: 3)
    |> validate_length(:email, max: 255)
    |> validate_length(:name, max: 255)
    |> validate_length(:password, min: 8)
    |> validate_length(:password, max: 255)
    |> validate_format(:name, ~r/^[a-zA-Z]+( [a-zA-Z]+)+$/)
    |> validate_format(:email, ~r/^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/)
    |> unique_constraint(:email)
  end
end
