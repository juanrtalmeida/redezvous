defmodule Redezvous.CreateSuggestionMutationTest do
  @moduledoc false
  use RedezvousWeb.ConnCase, async: true
  alias RedezvousWeb.Fixtures.ConnFixtures
  alias Redezvous.EventFactory

  test "should create a suggestion correctly", %{conn: conn} do
    # Arrange

    event = EventFactory.build_event!()

    query = """
    mutation {
      createSuggestion(name:"Random Suggestion", description:"This is gonna be a good suggestion", eventId: "#{event.id}"){
        date,
        description,
        id,
        location,
        name
      }
    }
    """

    authorized_conn = ConnFixtures.build_conn_with_valid_token(conn, %{email: "john_doe@example.com"})

    # Act
    result = post(authorized_conn, "/", %{query: query})

    # Assert
    assert %{
             "data" => %{
               "createSuggestion" => %{
                 "date" => _date,
                 "description" => "This is gonna be a good suggestion",
                 "id" => _id,
                 "location" => nil,
                 "name" => "Random Suggestion"
               }
             }
           } =
             result
             |> json_response(200)
  end

  test "should create a suggestion correctly with location", %{conn: conn} do
    # Arrange

    event = EventFactory.build_event!()

    query = """
    mutation {
      createSuggestion(name:"Random Suggestion", description:"This is gonna be a good suggestion", eventId: "#{event.id}", location: "Random Location"){
        date,
        description,
        id,
        location,
        name,
      }
    }
    """

    authorized_conn = ConnFixtures.build_conn_with_valid_token(conn, %{email: "john_doe@example.com"})

    # Act
    result = post(authorized_conn, "/", %{query: query})

    # Assert
    assert %{
             "data" => %{
               "createSuggestion" => %{
                 "date" => _date,
                 "description" => "This is gonna be a good suggestion",
                 "id" => _id,
                 "location" => "Random Location",
                 "name" => "Random Suggestion"
               }
             }
           } =
             result
             |> json_response(200)
  end

  test "should create a suggestion correctly with location and date", %{conn: conn} do
    # Arrange

    event = EventFactory.build_event!()

    query = """
    mutation {
      createSuggestion(name:"Random Suggestion", description:"This is gonna be a good suggestion", eventId: "#{event.id}", location: "Random Location", date: "2022-01-01T00:00:00Z"){
        date,
        description,
        id,
        location,
        name,
      }
    }
    """

    authorized_conn = ConnFixtures.build_conn_with_valid_token(conn, %{email: "john_doe@example.com"})

    # Act
    result = post(authorized_conn, "/", %{query: query})

    # Assert
    assert %{
             "data" => %{
               "createSuggestion" => %{
                 "date" => "2022-01-01T00:00:00Z",
                 "description" => "This is gonna be a good suggestion",
                 "id" => _id,
                 "location" => "Random Location",
                 "name" => "Random Suggestion"
               }
             }
           } =
             result
             |> json_response(200)
  end
end
