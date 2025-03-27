defmodule Redezvous.Vote.ManageVotes do
  @moduledoc """
  Documentation for ManageVotes.
  """
  alias Absinthe.Resolution
  alias Redezvous.Helpers.HandlerHelpers
  alias Redezvous.Models.{Event, Suggestion, User, Vote}
  alias Redezvous.Repo
  alias Absinthe.Subscription
  import Ecto.Query

  @spec create_new_vote(%{value: String.t(), suggestion_id: String.t()}, %Resolution{
          context: %{current_user: User.t()}
        }) ::
          {:ok, Vote.t()} | {:error, map()}
  def create_new_vote(params, _context = %Absinthe.Resolution{context: %{current_user: user = %User{}}}) do
    Repo.one(
      from s in Suggestion,
        left_join: e in Event,
        on: s.event_id == e.id,
        where:
          s.id == ^params.suggestion_id and
            not exists(from(v in Vote, where: v.suggestion_id == ^params.suggestion_id and v.user_id == ^user.id, limit: 1))
    )
    |> case do
      nil -> {:error, message: "Suggestion not found"}
      suggestion = %Suggestion{} -> 
        params 
        |> Map.put(:suggestion, suggestion) 
        |> Map.put(:created_by, user) 
        |> create_vote_changeset()
        |> maybe_broadcast_vote(params.suggestion_id)
    end
  end

  def create_vote_changeset(params) do
    Vote.changeset(%Vote{}, params)
    |> Repo.insert()
    |> HandlerHelpers.handle_insertion("Vote not created")
  end

  defp maybe_broadcast_vote({:ok, vote} = result, suggestion_id) do
    # Broadcast the new vote to all subscribers
    Subscription.publish(
      RedezvousWeb.Endpoint,
      vote,
      vote_added: "new_vote:#{suggestion_id}"
    )
    result
  end
  defp maybe_broadcast_vote(error, _), do: error
end
