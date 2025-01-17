defmodule Redezvous.SuggestionFactoryTest do
  @moduledoc false
  use RedezvousWeb.ConnCase, async: true
  alias Redezvous.Repo
  alias Redezvous.{EventFactory, SuggestionFactory, UserFactory}

  test "should create a suggestion correctly" do
    suggestion =
      SuggestionFactory.build_suggestion!(
        %{name: "Random Suggestion", description: "This is gonna be a good suggestion", location: "Random Location", date: "2022-01-01T00:00:00Z"},
        event = EventFactory.build_event!(UserFactory.build_user!(%{name: "Naruto Uzumaki", email: "naruto@konoha.com"})),
        suggestion_user = UserFactory.build_user!(%{name: "Sasuke Uchiha", email: "uchiha_sasuke@konoha.com"})
      )

    assert suggestion.description == "This is gonna be a good suggestion"
    assert suggestion.name == "Random Suggestion"
    assert suggestion.date |> DateTime.to_string() == "2022-01-01 00:00:00Z"
    assert suggestion.location == "Random Location"
    assert suggestion.event |> Repo.preload([:created_by, :guests]) == event
    assert suggestion.user == suggestion_user
  end

  test "should create a suggestion correctly without date" do
    suggestion =
      SuggestionFactory.build_suggestion!(
        %{name: "Random Suggestion", description: "This is gonna be a good suggestion", location: "Random Location"},
        event = EventFactory.build_event!(UserFactory.build_user!(%{name: "Naruto Uzumaki", email: "naruto@konoha.com"})),
        suggestion_user = UserFactory.build_user!(%{name: "Sasuke Uchiha", email: "uchiha_sasuke@konoha.com"})
      )

    assert suggestion.description == "This is gonna be a good suggestion"
    assert suggestion.name == "Random Suggestion"
    assert suggestion.location == "Random Location"
    assert suggestion.event |> Repo.preload([:created_by, :guests]) == event
    assert suggestion.user == suggestion_user
  end
end
