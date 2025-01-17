defmodule Redezvous.CreateVotesMutationTest do
  @moduledoc false
  use RedezvousWeb.ConnCase, async: true
  alias Redezvous.EventFactory
  alias Redezvous.SuggestionFactory
  alias Redezvous.UserFactory
  alias RedezvousWeb.Fixtures.ConnFixtures

  test "should create a vote correctly with value true", %{conn: conn} do
    # Arrange
    suggestion =
      SuggestionFactory.build_suggestion!(
        %{},
        EventFactory.build_event!(UserFactory.build_user!(%{name: "Naruto Uzumaki", email: "naruto@konoha.com"}), %{title: "Battle on the valley of the end"}),
        UserFactory.build_user!(%{name: "Sasuke Uchiha", email: "uchiha_sasuke@konoha.com"})
      )

    query = """
    mutation {
    createVote(suggestionId:"#{suggestion.id}",value: true){
    value
    }
    }
    """

    authorized_conn = ConnFixtures.build_conn_with_valid_token(conn, %{email: "john_doe@example.com"})

    # Act
    result = post(authorized_conn, "/", %{query: query})

    # Assert
    assert %{
             "data" => %{
               "createVote" => %{
                 "value" => true
               }
             }
           } =
             result
             |> json_response(200)
  end

  test "should create a vote correctly with value false", %{conn: conn} do
    # Arrange
    suggestion =
      SuggestionFactory.build_suggestion!(
        %{},
        EventFactory.build_event!(UserFactory.build_user!(%{name: "Naruto Uzumaki", email: "naruto@konoha.com"}), %{title: "Battle on the valley of the end"}),
        UserFactory.build_user!(%{name: "Sasuke Uchiha", email: "uchiha_sasuke@konoha.com"})
      )

    query = """
    mutation {
    createVote(suggestionId:"#{suggestion.id}",value: false){
    value
    }
    }
    """

    authorized_conn = ConnFixtures.build_conn_with_valid_token(conn, %{email: "john_doe@example.com"})

    # Act
    result = post(authorized_conn, "/", %{query: query})

    # Assert
    assert %{
             "data" => %{
               "createVote" => %{
                 "value" => false
               }
             }
           } =
             result
             |> json_response(200)
  end
end
