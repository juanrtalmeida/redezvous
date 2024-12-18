defmodule RedezvousWeb.Schema do
  @moduledoc """
  Documentation for Schema.
  """
  use Absinthe.Schema

  import_types(RedezvousWeb.SchemaTypes)

  query do
    @desc "List all users"
    field :users, list_of(:user) do
      arg(:name, non_null(:string))
      resolve(&Redezvous.list_users/3)
    end
  end
end
