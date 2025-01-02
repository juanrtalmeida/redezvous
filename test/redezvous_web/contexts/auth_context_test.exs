defmodule RedezvousWeb.AuthContextTest do
  use RedezvousWeb.ConnCase, async: true
  alias RedezvousWeb.Contexts.AuthContext
  alias Support.Fixtures.ConnFixtures
  alias Redezvous.Models.User

  test "should build context and set current user", %{conn: conn} do
    updated_conn =
      conn
      |> ConnFixtures.build_conn_with_valid_token()
      |> AuthContext.call([])

    assert %Plug.Conn{
             private: %{absinthe: %{context: %{current_user: %User{}}}}
           } = updated_conn
  end

  test "should not set current user if token is invalid", %{conn: conn} do
    updated_conn =
      conn
      |> AuthContext.call([])

    assert updated_conn.private.absinthe.context == %{}
  end

  test "should not set current user if token is expired", %{conn: conn} do
    updated_conn =
      conn
      |> ConnFixtures.build_conn_with_expired_token()
      |> AuthContext.call([])

    assert updated_conn.private.absinthe.context.expired == true
  end

  test "should not set current user if token is not found", %{conn: conn} do
    updated_conn =
      conn
      |> AuthContext.call([])

    assert updated_conn.private.absinthe.context == %{}
  end

  test "should return error if token is expired", %{conn: conn} do
    updated_conn =
      conn
      |> ConnFixtures.build_conn_with_expired_token()
      |> AuthContext.build_context()

    assert updated_conn.expired == true
  end

  test "should return current user if token is valid", %{conn: conn} do
    updated_conn =
      conn
      |> ConnFixtures.build_conn_with_valid_token()
      |> AuthContext.build_context()

    assert %User{} = updated_conn.current_user
  end
end
