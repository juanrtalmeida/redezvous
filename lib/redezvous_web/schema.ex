defmodule RedezvousWeb.Schema do
  @moduledoc """
  Documentation for Schema.
  """
  use Absinthe.Schema

  import_types(RedezvousWeb.SchemaTypes)

  query do
    @desc "List all users"
    field :users, list_of(:user) do
      arg(:filter, :user_filter)
      resolve(&Redezvous.list_users/3)
    end

    @desc "User infos query"
    field :user, :user do
      arg(:id, non_null(:string))
      resolve(&Redezvous.user_infos/3)
    end

    @desc "Event infos query"
    field :event, :event do
      arg(:id, non_null(:string))
      resolve(&Redezvous.list_events/3)
    end
  end

  input_object :user_filter do
    field :name, :string
    field :email, :string
  end
end
