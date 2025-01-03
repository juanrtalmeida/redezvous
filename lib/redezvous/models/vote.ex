defmodule Redezvous.Models.Vote do
  use Ecto.Schema
  alias Redezvous.Models.{User, Suggestion}

  @moduledoc """
  Documentation for Vote.
  """

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "votes" do
    field :value, :boolean
    belongs_to :user, User
    belongs_to :suggestion, Suggestion
    timestamps()
  end
end
