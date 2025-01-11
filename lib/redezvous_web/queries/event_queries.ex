defmodule RedezvousWeb.Queries.EventQueries do
  @moduledoc """
  Documentation for EventQueries.
  """
  use Absinthe.Schema.Notation

  object :event_queries do
    @desc "Get event infos"
    field :event_infos, :event do
      arg(:event_id, non_null(:id), description: "Id for the event")
      resolve(&Redezvous.get_event_infos/2)
    end
  end
end
