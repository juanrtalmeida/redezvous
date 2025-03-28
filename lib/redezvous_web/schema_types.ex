defmodule RedezvousWeb.SchemaTypes do
  @moduledoc """
  Documentation for SchemaTypes.
  """
  use Absinthe.Schema.Notation
  import_types(Absinthe.Type.Custom)

  object :user do
    field :id, :id
    field :name, :string
    field :email, :string

    field :created_events, list_of(:event) do
      resolve(&Redezvous.list_created_events/2)
    end

    field :created_suggestions, list_of(:suggestion) do
      resolve(&Redezvous.list_created_suggestions/2)
    end

    field :created_votes, list_of(:vote) do
      resolve(&Redezvous.list_created_votes/2)
    end
  end

  object :suggestion do
    field :id, :id
    field :name, :string
    field :description, :string
    field :location, :string
    field :date, :datetime
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
    field :title, :string
    field :description, :string
    field :location, :string
    field :date, :datetime
    field :finished, :boolean
    field :cancelled, :boolean

    field :suggestions, list_of(:suggestion) do
      resolve(&Redezvous.list_suggestions/3)
    end

    field :created_by, :user do
      resolve(&Redezvous.event_created_by/3)
    end

    field :guests, list_of(:user) do
      resolve(&Redezvous.list_guests/3)
    end
  end
end
