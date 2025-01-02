defmodule Redezvous.Models.Vote do
  use Ecto.Schema
  alias Redezvous.Models.{User, Suggestion}

  @moduledoc """
  Documentation for Vote.
  """
  schema "vote" do
    field :value, :boolean
    belongs_to :user_id, User
    belongs_to :suggestion, Suggestion
    timestamps()
  end
end
