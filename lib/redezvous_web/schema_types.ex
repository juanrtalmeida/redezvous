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
    field :date, :datetime
    field :created_by, :id
    field :finished, :boolean
    field :cancelled, :boolean
  end
end
