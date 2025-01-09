defmodule Redezvous.Accounts.AccountFieldsResolvers do
  @moduledoc false
  alias Redezvous.Models.User
  alias Redezvous.Repo

  def list_created_votes(_params, %Absinthe.Resolution{context: %{current_user: user = %User{}}}) do
    user_fetched = user |> Repo.preload(:votes)
    {:ok, user_fetched.votes}
  end

  def list_created_suggestions(_params, %Absinthe.Resolution{context: %{current_user: user = %User{}}}) do
    user_fetched = user |> Repo.preload(:suggestions)
    {:ok, user_fetched.suggestions}
  end

  def list_created_events(_params, %Absinthe.Resolution{context: %{current_user: user = %User{}}}) do
    user_fetched = user |> Repo.preload(:events)
    {:ok, user_fetched.events}
  end
end
