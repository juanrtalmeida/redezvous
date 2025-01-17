defmodule Redezvous.VoteFactoryTest do
  @moduledoc false
  alias Redezvous.{VoteFactory, SuggestionFactory, UserFactory, EventFactory}
  alias Redezvous.Repo
  use RedezvousWeb.ConnCase, async: true

  test "should create a vote correctly" do
    user = UserFactory.build_user!(%{name: "Naruto Uzumaki", email: "naruto@konoha.com"})

    vote =
      VoteFactory.build_vote!(
        %{value: true},
        suggestion =
          SuggestionFactory.build_suggestion!(
            %{
              name: "Random Suggestion",
              description: "This is gonna be a good suggestion",
              location: "Random Location",
              date: "2022-01-01T00:00:00Z"
            },
            EventFactory.build_event!(user),
            user
          ),
        user
      )

    assert vote.value == true
    assert vote.user == user
    assert vote.suggestion |> Repo.preload([:event, :user]) == suggestion
  end

  test "should throw error creating vote" do
    assert_raise RuntimeError, fn ->
      user = UserFactory.build_user!(%{name: "Naruto Uzumaki", email: "naruto@konoha.com"})

      VoteFactory.build_vote!(
        %{value: "true in string"},
        SuggestionFactory.build_suggestion!(
          %{
            name: "Random Suggestion",
            description: "This is gonna be a good suggestion",
            location: "Random Location",
            date: "2022-01-01T00:00:00Z"
          },
          EventFactory.build_event!(user),
          user
        ),
        user
      )
    end
  end
end
