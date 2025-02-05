defmodule RedezvousWeb.Schema do
  @moduledoc """
  Documentation for Schema.
  """
  use Absinthe.Schema
  alias RedezvousWeb.Middlewares.AuthMiddleware

  import_types(RedezvousWeb.SchemaTypes)
  import_types(RedezvousWeb.Mutations.EventMutations)
  import_types(RedezvousWeb.Mutations.UserMutations)
  import_types(RedezvousWeb.Queries.EventQueries)
  import_types(RedezvousWeb.Mutations.SuggestionMutations)
  import_types(RedezvousWeb.Mutations.VoteMutations)

  query do
    import_fields(:event_queries)
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
    import_fields(:event_mutations)
    import_fields(:user_mutations)
    import_fields(:suggestion_mutations)
    import_fields(:vote_mutations)
  end
end
