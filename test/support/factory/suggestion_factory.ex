defmodule Redezvous.SuggestionFactory do
  @moduledoc """
  Documentation for SuggestionFactory.
  """
  alias Absinthe.Resolution
  alias Redezvous.Models.{Event, User, Suggestion}
  alias Redezvous.{EventFactory, UserFactory}
  alias Redezvous.Suggestion.ManageSuggestions

  @default_params %{
    location: "Konoha",
    description: "Rasengan vs Chidorin on the rooftop",
    date: DateTime.utc_now() |> DateTime.to_string(),
    name: "Naruto vs Sasukere"
  }

  @spec build_suggestion(map(), Event.t(), User.t()) :: Suggestion.t() | no_return()
  def build_suggestion(
        params \\ %{},
        event = %Event{} \\ EventFactory.build_event!(UserFactory.build_user!(%{name: "Naruto Uzumaki", email: "naruto@konoha.com"})),
        user = %User{} \\ UserFactory.build_user!()
      ) do
    @default_params
    |> Map.merge(params)
    |> Map.put(:event_id, event.id)
    |> ManageSuggestions.create_new_suggestion(%Resolution{context: %{current_user: user}})
    |> case do
      {:ok, suggestion = %Suggestion{}} -> suggestion
      {:error, changeset} -> raise "Suggestion not created: #{inspect(changeset)}"
    end
  end
end
