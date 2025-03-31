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
    field :user, non_null(:user) do
      middleware(AuthMiddleware)
      resolve(&Redezvous.user_infos/2)
    end
  end

  mutation do
    import_fields(:event_mutations)
    import_fields(:user_mutations)
    import_fields(:suggestion_mutations)
    import_fields(:vote_mutations)

    @desc "Create login token"
    field :create_login_token, non_null(:string) do
      arg(:email, non_null(:string), description: "User email")
      arg(:password, non_null(:string), description: "User password")
      resolve(&Redezvous.create_login_token/2)
    end
  end

  subscription do
    @desc "Subscribe to new suggestions for an event"
    field :suggestion_added, :suggestion do
      arg(:event_id, non_null(:id))
      
      config fn args, _info ->
        {:ok, topic: "new_suggestion:#{args.event_id}"}
      end
    end

    @desc "Subscribe to new votes for a suggestion"
    field :vote_added, :vote do
      arg(:suggestion_id, non_null(:id))
      
      config fn args, _info ->
        {:ok, topic: "new_vote:#{args.suggestion_id}"}
      end
    end

    @desc "Subscribe to event updates"
    field :event_updated, :event do
      arg(:event_id, non_null(:id))
      
      config fn args, _info ->
        {:ok, topic: "event_updated:#{args.event_id}"}
      end
    end
  end
end
