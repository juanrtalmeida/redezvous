defmodule Redezvous.Models.Suggestion do
  use Ecto.Schema
  alias Redezvous.Models.{User, Event}

  @moduledoc """
  Documentation for Suggestion.
  """
  schema "suggestion" do
    field :name, :string
    field :description, :string
    field :location, :string
    field :date, :utc_datetime, default: nil
    belongs_to :event, Event
    belongs_to :user, User

    timestamps()
  end
end
