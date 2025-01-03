defmodule RedezvousWeb.Schema do
  @moduledoc """
  Documentation for Schema.
  """
  use Absinthe.Schema
  alias RedezvousWeb.Middlewares.AuthMiddleware

  import_types(RedezvousWeb.SchemaTypes)

  query do
    @desc "User infos query"
    field :user, :user do
      middleware(AuthMiddleware)
      resolve(&Redezvous.user_infos/2)
    end

    @desc "Create login token"
    field :create_login_token, :string do
      arg(:email, non_null(:string), description: "User email")
      arg(:password, non_null(:string), description: "User password")
      resolve(&Redezvous.create_login_token/2)
    end
  end

  mutation do
    @desc "register a new user"
    field :register_user, :user do
      arg(:name, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Redezvous.create_new_user/2)
    end
  end
end
