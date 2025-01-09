defmodule Redezvous.CreateEventMutationTest do
  @moduledoc false
  use RedezvousWeb.ConnCase, async: true
  alias Redezvous.Helpers.StringHelpers
  alias Redezvous.UserFactory
  alias RedezvousWeb.Fixtures.ConnFixtures

  test "should create a basic event correctly", %{conn: conn} do
    # Arrange
    query = """
    mutation {
    createEvent(title:"Random Event", description:"This is gonna be a good event"){
    cancelled,
    createdBy{
      id
    },
    date,
    description,
    finished,
    id,
    location,
    title
    }
    }
    """

    authorized_conn = ConnFixtures.build_conn_with_valid_token(conn)
    # Act
    result = post(authorized_conn, "/", %{query: query})

    # Assert
    assert %{
             "data" => %{
               "createEvent" => %{
                 "cancelled" => false,
                 "createdBy" => %{
                   "id" => id_user
                 },
                 "date" => nil,
                 "description" => "This is gonna be a good event",
                 "finished" => false,
                 "id" => id_event,
                 "location" => nil,
                 "title" => "Random Event"
               }
             }
           } = json_response(result, 200)

    assert is_binary(id_user)
    assert is_binary(id_event)
  end

  test "should create a event with location correctly", %{conn: conn} do
    # Arrange
    query = """
    mutation {
    createEvent(title:"Random Event", description:"This is gonna be a good event", location:"Random Location"){
    cancelled,
    location,
    createdBy{
      id
    },
    date,
    description,
    finished,
    id,
    location,
    title
    }
    }
    """

    authorized_conn = ConnFixtures.build_conn_with_valid_token(conn)
    # Act
    result = post(authorized_conn, "/", %{query: query})

    # Assert
    assert %{
             "data" => %{
               "createEvent" => %{
                 "cancelled" => false,
                 "createdBy" => %{
                   "id" => id_user
                 },
                 "date" => nil,
                 "description" => "This is gonna be a good event",
                 "finished" => false,
                 "id" => id_event,
                 "title" => "Random Event",
                 "location" => "Random Location"
               }
             }
           } = json_response(result, 200)

    assert is_binary(id_user)
    assert is_binary(id_event)
  end

  test "should create a event with location and date correctly", %{conn: conn} do
    # Arrange
    query = """
    mutation {
    createEvent(title:"Random Event", description:"This is gonna be a good event", location:"Random Location", date:"2022-01-01T00:00:00Z"){
    cancelled,
    location,
    createdBy{
      id
    },
    date,
    description,
    finished,
    id,
    date,
    location,
    title
    }
    }
    """

    authorized_conn = ConnFixtures.build_conn_with_valid_token(conn)
    # Act
    result = post(authorized_conn, "/", %{query: query})

    # Assert
    assert %{
             "data" => %{
               "createEvent" => %{
                 "cancelled" => false,
                 "createdBy" => %{
                   "id" => id_user
                 },
                 "date" => "2022-01-01T00:00:00Z",
                 "description" => "This is gonna be a good event",
                 "finished" => false,
                 "id" => id_event,
                 "title" => "Random Event",
                 "location" => "Random Location"
               }
             }
           } = json_response(result, 200)

    assert is_binary(id_user)
    assert is_binary(id_event)
  end

  test "should fail to create event with invalid date", %{conn: conn} do
    # Arrange
    query = """
    mutation {
    createEvent(title:"Random Event", description:"This is gonna be a good event", location:"Random Location", date:"2022-01-01"){
    cancelled,
    location,
    createdBy{
      id
    },
    date,
    description,
    finished,
    id,
    date,
    location,
    title
    }
    }
    """

    authorized_conn = ConnFixtures.build_conn_with_valid_token(conn)
    # Act
    result = post(authorized_conn, "/", %{query: query})

    # Assert
    assert %{
             "data" => %{
               "createEvent" => nil
             },
             "errors" => [
               %{
                 "errors" => %{"date" => "is invalid"},
                 "message" => "Event not created"
               }
             ]
           } = json_response(result, 200)
  end

  test "should create a event with a list of guests correctly", %{conn: conn} do
    # Arrange

    users_emails =
      Enum.map(1..4, fn _ ->
        user = UserFactory.build_user!(%{email: StringHelpers.create_random_email()})
        user.email
      end)

    query =
      """
      mutation {
      createEvent(title:"Random Event", description:"This is gonna be a good event", location:"Random Location", guests: [#{users_emails |> Enum.map_join(",", fn email -> "\"#{email}\"" end)}]){
      cancelled,
      location,
      createdBy{
        id
      },
      date,
      description,
      finished,
      id,
      date,
      location,
      title,
      guests {
        email
        }
      }
      }
      """

    authorized_conn = ConnFixtures.build_conn_with_valid_token(conn)

    # Act
    result = post(authorized_conn, "/", %{query: query})

    guests_assertion = users_emails |> Enum.map(fn email -> %{"email" => email} end)
    # Assert
    assert %{
             "data" => %{
               "createEvent" => %{
                 "cancelled" => false,
                 "createdBy" => %{
                   "id" => id_user
                 },
                 "date" => nil,
                 "description" => "This is gonna be a good event",
                 "finished" => false,
                 "id" => id_event,
                 "title" => "Random Event",
                 "location" => "Random Location",
                 "guests" => guests
               }
             }
           } = json_response(result, 200)

    assert is_binary(id_user)
    assert is_binary(id_event)
    assert guests == guests_assertion
  end
end
