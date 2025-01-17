defmodule Redezvous.Vote.VotesFieldsResolvers do
  @moduledoc false
  alias Redezvous.Repo

  def list_votes(parent, _params, _context = %Absinthe.Resolution{}) do
    fetched_votes =
      parent
      |> Repo.preload(:votes)
      |> Map.get(:votes)

    {:ok, fetched_votes}
  end
end
