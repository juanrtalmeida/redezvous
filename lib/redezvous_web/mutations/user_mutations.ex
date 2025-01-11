defmodule RedezvousWeb.Mutations.UserMutations do
  @moduledoc """
  Documentation for CreateEventMutation.
  """
  use Absinthe.Schema.Notation

  object :user_mutations do
    @desc "register a new user"
    field :register_user, :user do
      arg(:name, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Redezvous.create_new_user/2)
    end
  end
end
