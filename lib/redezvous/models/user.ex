defmodule Redezvous.Models.User do
  use Ecto.Schema
  alias Redezvous.Models.{Event, Vote, Suggestion}

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
    has_many :suggestions, Suggestion
    has_many :votes, Vote
    has_many :events, Event

    timestamps()
  end
end
