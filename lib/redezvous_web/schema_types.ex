defmodule RedezvousWeb.SchemaTypes do
  @moduledoc """
  Documentation for SchemaTypes.
  """
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :name, :string
    field :email, :string

    field :suggestions, list_of(:suggestion) do
      resolve(&Redezvous.list_suggestions/3)
    end

    field :votes, list_of(:vote) do
      resolve(&Redezvous.list_votes/3)
    end

    field :events, list_of(:event) do
      resolve(&Redezvous.list_events/3)
    end

    field :created_events, list_of(:event) do
      resolve(&Redezvous.list_created_events/3)
    end

    field :created_suggestions, list_of(:suggestion) do
      resolve(&Redezvous.list_created_suggestions/3)
    end

    field :created_votes, list_of(:vote) do
      resolve(&Redezvous.list_created_votes/3)
    end
  end

  object :suggestion do
    field :id, :id
    field :name, :string
    field :description, :string
    field :location, :string
    field :date, :utc_datetime
    field :event_id, :id
    field :user_id, :id

    field :votes, list_of(:vote) do
      resolve(&Redezvous.list_votes/3)
    end
  end

  object :vote do
    field :id, :id
    field :value, :boolean
    field :user_id, :id
    field :suggestion_id, :id
  end

  object :event do
    field :id, :id
    field :name, :string
    field :description, :string
    field :location, :string
    field :date, :utc_datetime

    field :suggestions, list_of(:suggestion) do
      resolve(&Redezvous.list_suggestions/3)
    end
  end
end
