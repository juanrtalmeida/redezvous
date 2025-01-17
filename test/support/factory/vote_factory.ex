defmodule Redezvous.VoteFactory do
  @moduledoc """
  Documentation for VoteFactory.
  """
  alias Redezvous.Vote.ManageVotes
  alias Redezvous.Models.{Suggestion, User, Vote}
  alias Redezvous.{SuggestionFactory, UserFactory}

  @default_params %{
    value: true
  }
  @spec build_vote!(map(), Suggestion.t(), User.t()) :: Vote.t() | no_return()
  def build_vote!(
        params \\ %{},
        suggestion = %Suggestion{} \\ SuggestionFactory.build_suggestion!(),
        user = %User{} \\ UserFactory.build_user!()
      ) do
    @default_params
    |> Map.merge(params)
    |> Map.put(:suggestion_id, suggestion.id)
    |> ManageVotes.create_new_vote(%Absinthe.Resolution{context: %{current_user: user}})
    |> case do
      {:ok, vote = %Vote{}} -> vote
      {:error, changeset} -> raise "Vote not created: #{inspect(changeset)}"
    end
  end
end
