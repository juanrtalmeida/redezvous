defmodule RedezvousWeb.Schema do
  @moduledoc """
  Documentation for Schema.
  """
  use Absinthe.Schema

  import_types(RedezvousWeb.SchemaTypes)

  query do
    @desc "User infos query"
    field :user, :user do
      arg(:id, non_null(:string))
      resolve(&Redezvous.user_infos/3)
    end
  end

  query do
    @desc "Event infos query"
    field :event, :event do
      arg(:id, non_null(:string))
      resolve(&Redezvous.list_events/3)
    end
  end
end
