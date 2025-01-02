defmodule Redezvous.CreateUserMutationTest do
  use RedezvousWeb.ConnCase, async: true
  alias Redezvous.Repo
  alias Redezvous.Models.User
  alias Redezvous.UserFactory

  test "should create a user correctly", %{conn: conn} do
    # Arrange
    query = """
    mutation {
      registerUser(email: "test@test.com", password: "password", name: "test test") {
        id
      }
    }
    """

    # Act
    conn = post(conn, "/", %{query: query})

    # Assert
    user = Repo.get_by(User, email: "test@test.com")
    assert json_response(conn, 200) == %{"data" => %{"registerUser" => %{"id" => user.id}}}
  end

  test "should not create a user if the email is already taken", %{conn: conn} do
    # Arrange
    query = """
    mutation {
      registerUser(email: "test@test.com", password: "password", name: "test test") {
        id
      }
    }
    """

    UserFactory.build_user!(%{email: "test@test.com"})

    # Act
    conn = post(conn, "/", %{query: query})

    # Assert
    response = json_response(conn, 200)

    assert %{
             "data" => %{"registerUser" => nil},
             "errors" => [
               %{
                 "errors" => %{"email" => "has already been taken"},
                 "message" => "User not created"
               }
             ]
           } = response
  end

  test "should not create a user if the email is invalid", %{conn: conn} do
    # Arrange
    query = """
    mutation {
      registerUser(email: "test", password: "password", name: "test test") {
        id
      }
    }
    """

    # Act
    conn = post(conn, "/", %{query: query})

    # Assert
    response = json_response(conn, 200)

    assert %{
             "data" => %{"registerUser" => nil},
             "errors" => [
               %{
                 "errors" => %{"email" => "has invalid format"},
                 "message" => "User not created"
               }
             ]
           } = response
  end

  test "should not create a user if the password is invalid", %{conn: conn} do
    # Arrange
    query = """
    mutation {
      registerUser(email: "test@test.com", password: "123", name: "test test") {
        id
      }
    }
    """

    # Act
    conn = post(conn, "/", %{query: query})

    # Assert
    response = json_response(conn, 200)

    assert %{
             "data" => %{"registerUser" => nil},
             "errors" => [
               %{
                 "errors" => %{"password" => "should be at least 8 character(s)"},
                 "message" => "User not created"
               }
             ]
           } = response
  end

  test "should not create a user if the name is invalid", %{conn: conn} do
    # Arrange
    query = """
    mutation {
      registerUser(email: "test@test.com", password: "password", name: "test") {
        id
      }
    }
    """

    # Act
    conn = post(conn, "/", %{query: query})

    # Assert
    response = json_response(conn, 200)

    assert %{
             "data" => %{"registerUser" => nil},
             "errors" => [
               %{
                 "errors" => %{"name" => "has invalid format"},
                 "message" => "User not created"
               }
             ]
           } = response
  end

  test "should not create a user if the name has invalid characters", %{conn: conn} do
    # Arrange
    query = """
    mutation {
      registerUser(email: "test@test.com", password: "password", name: "test test!") {
        id
      }
    }
    """

    # Act
    conn = post(conn, "/", %{query: query})

    # Assert
    response = json_response(conn, 200)

    assert %{
             "data" => %{"registerUser" => nil},
             "errors" => [
               %{
                 "errors" => %{"name" => "has invalid format"},
                 "message" => "User not created"
               }
             ]
           } = response
  end
end
