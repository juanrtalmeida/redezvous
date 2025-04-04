defmodule RedezvousWeb.Mutations.EventMutations do
  @moduledoc """
  Documentation for CreateEventMutation.
  """
  alias RedezvousWeb.Middlewares.AuthMiddleware
  use Absinthe.Schema.Notation

  object :event_mutations do
    @desc "Create a new event"
    field :create_event, :event do
      arg(:title, non_null(:string))
      arg(:description, non_null(:string))
      arg(:date, :string, description: "Date in format YYYY-MM-DD")
      arg(:location, :string)
      arg(:guests, list_of(:string), description: "List of guest emails")
      middleware(AuthMiddleware)
      resolve(&Redezvous.create_new_event/2)
    end

    @desc "Update an existing event"
    field :update_event, :event do
      arg(:id, non_null(:id))
      arg(:title, :string)
      arg(:description, :string)
      arg(:date, :string, description: "Date in format YYYY-MM-DD")
      arg(:location, :string)
      arg(:guests, list_of(:string), description: "List of guest emails")
      middleware(AuthMiddleware)
      resolve(&Redezvous.update_event/2)
    end

    @desc "Join an event"
    field :join_event, :event do
      arg(:id, non_null(:id))
      middleware(AuthMiddleware)
      resolve(&Redezvous.join_event/2)
    end
  end
end
