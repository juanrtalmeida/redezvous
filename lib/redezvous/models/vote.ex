defmodule Redezvous.Models.Vote do
  use Ecto.Schema
  import Ecto.Changeset
  alias Redezvous.Models.{Suggestion, User}

  @moduledoc """
  Documentation for Vote.
  """

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @type t :: %__MODULE__{
          id: binary(),
          value: boolean(),
          user: User.t(),
          suggestion: Suggestion.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "votes" do
    field :value, :boolean
    belongs_to :user, User
    belongs_to :suggestion, Suggestion
    timestamps()
  end

  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:value, :suggestion_id])
    |> validate_required([:value, :suggestion_id])
    |> validate_inclusion(:value, [true, false])
    |> put_assoc(:user, attrs.created_by)
    |> put_assoc(:suggestion, attrs.suggestion)
  end
end
