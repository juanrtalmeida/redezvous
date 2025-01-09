defmodule RedezvousWeb.Queries.UserInfosQueryTest do
  @moduledoc false
  alias Redezvous.Models.User
  alias Redezvous.Repo
  use RedezvousWeb.ConnCase, async: true
  alias RedezvousWeb.Fixtures.ConnFixtures

  @user_infos_query """
  query {
  user {
  id,
  email,
  name,
  createdVotes{
    id,
    value
  },
  createdEvents{
    cancelled,
    createdBy{
      id
    },
    date,
    description,
    finished,
    location,
    title
  },
  createdSuggestions{
    date,
    description,
    eventId,
    id,
    location,
    name
  }
  }
  }
  """

  test "should get user basic infos", %{conn: conn} do
    # Arrange
    query = @user_infos_query
    authorized_conn = ConnFixtures.build_conn_with_valid_token(conn)
    # Act
    response = post(authorized_conn, "/", %{query: query})

    # Assert
    user = Repo.get_by(User, email: "test@test.com") |> Repo.preload([:events, :suggestions, :votes])

    assert json_response(response, 200) == %{
             "data" => %{
               "user" => %{"id" => user.id, "email" => user.email, "name" => user.name, "createdVotes" => [], "createdEvents" => [], "createdSuggestions" => []}
             }
           }
  end

  test "should fail to get user infos if not authorized", %{conn: conn} do
    # Arrange
    query = @user_infos_query
    # Act
    response = post(conn, "/", %{query: query})

    # Assert
    assert %{"data" => %{"user" => nil}, "errors" => [%{"message" => "Unauthorized"}]} = json_response(response, 200)
  end
end
