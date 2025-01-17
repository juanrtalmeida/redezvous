defmodule Redezvous.Suggestion.ManageSuggestions do
  @moduledoc false
  import Ecto.Query
  alias Absinthe.Resolution
  alias Redezvous.Helpers.HandlerHelpers
  alias Redezvous.Models.{Event, Suggestion, User}
  alias Redezvous.Repo

  @spec create_new_suggestion(
          %{name: String.t(), description: String.t(), event_id: String.t(), location: String.t()},
          %Resolution{
            context: %{current_user: User.t()}
          }
        ) ::
          {:ok, Suggestion.t()} | {:error, map()}
  def create_new_suggestion(params, _context = %Resolution{context: %{current_user: user = %User{}}}) do
    Repo.one(from e in Event, where: e.id == ^params.event_id and not e.cancelled and not e.finished)
    |> case do
      nil -> {:error, message: "Event not found"}
      event = %Event{} -> params |> Map.put(:event, event) |> Map.put(:created_by, user) |> create_suggestion_changeset()
    end
  end

  def create_suggestion_changeset(params) do
    Suggestion.changeset(%Suggestion{}, params)
    |> Repo.insert()
    |> HandlerHelpers.handle_insertion("Suggestion not created")
  end

  def list_suggestions(parent, _params, _contexts) do
    parent
    |> Repo.preload(:suggestions)
    |> Map.get(:suggestions)
    |> HandlerHelpers.handle_search()
  end
end
