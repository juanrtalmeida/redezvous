defmodule RedezvousWeb.Mutations.VoteMutations do
  @moduledoc """
  Documentation for VoteMutations.
  """
  use Absinthe.Schema.Notation
  alias RedezvousWeb.Middlewares.AuthMiddleware

  object :vote_mutations do
    @desc "Create a new vote"
    field :create_vote, :vote do
      middleware(AuthMiddleware)
      arg(:value, non_null(:boolean))
      arg(:suggestion_id, non_null(:id))
      resolve(&Redezvous.create_new_vote/2)
    end
  end
end
