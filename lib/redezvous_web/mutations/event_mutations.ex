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
      middleware(AuthMiddleware)
      resolve(&Redezvous.create_new_event/2)
    end
  end
end
