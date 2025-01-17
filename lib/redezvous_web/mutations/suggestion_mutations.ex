defmodule RedezvousWeb.Mutations.SuggestionMutations do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias RedezvousWeb.Middlewares.AuthMiddleware

  object :suggestion_mutations do
    @desc "Create a new suggestion"
    field :create_suggestion, :suggestion do
      middleware(AuthMiddleware)
      arg(:name, non_null(:string))
      arg(:description, non_null(:string))
      arg(:location, :string)
      arg(:event_id, non_null(:id))
      arg(:date, :string, description: "Date in format YYYY-MM-DD")

      resolve(&Redezvous.create_new_suggestion/2)
    end
  end
end
