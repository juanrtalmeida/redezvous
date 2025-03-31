defmodule RedezvousWeb.SchemaTypes do
  @moduledoc """
  Documentation for SchemaTypes.
  """
  use Absinthe.Schema.Notation
  import_types(Absinthe.Type.Custom)

  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)

    field :created_events, non_null(list_of(:event)) do
      resolve(&Redezvous.list_created_events/2)
    end

    field :created_suggestions, non_null(list_of(:suggestion)) do
      resolve(&Redezvous.list_created_suggestions/2)
    end

    field :created_votes, non_null(list_of(:vote)) do
      resolve(&Redezvous.list_created_votes/2)
    end
  end

  object :suggestion do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :description, non_null(:string)
    field :location, non_null(:string)
    field :date, non_null(:datetime)
    field :event_id, non_null(:id)
    field :user_id, non_null(:id)

    field :votes, list_of(:vote) do
      resolve(&Redezvous.list_votes/3)
    end
  end

  object :vote do
    field :id, non_null(:id)
    field :value, non_null(:boolean)
    field :user_id, non_null(:id)
    field :suggestion_id, non_null(:id)
  end

  object :event do
    field :id, non_null(:id)
    field :title, non_null(:string)
    field :description, non_null(:string)
    field :location, :string
    field :date, :datetime
    field :finished, non_null(:boolean)
    field :cancelled, non_null(:boolean)

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
