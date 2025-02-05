defmodule Redezvous.AuthTest do
  use Redezvous.DataCase, async: true

  alias Redezvous.Auth
  alias Redezvous.Models.User
  alias Redezvous.UserFactory

  test "should create a login token" do
    user = UserFactory.build_user!()
    token = Auth.create_token(user, 1000)
    assert is_binary(token)
  end

  test "should make successful login" do
    user = UserFactory.build_user!(%{password: "password"})
    assert {:ok, token} = Auth.login(%{email: user.email, password: "password"}, [])
    assert is_binary(token)
  end

  test "should not make login if the password is incorrect" do
    user = UserFactory.build_user!(%{password: "password"})
    assert {:error, "Invalid password"} = Auth.login(%{email: user.email, password: "wrong_password"}, [])
  end

  test "should not make login if the user is not found" do
    assert {:error, "User not found"} = Auth.login(%{email: "unknown@example.com", password: "password"}, [])
  end

  test "should authorize a valid token" do
    user = UserFactory.build_user!()
    token = Auth.create_token(user, 1000)
    assert {:ok, user} = Auth.authorize(token)
    assert %User{} = user
  end

  test "should not authorize an invalid token" do
    assert {:error, "Invalid token"} = Auth.authorize("invalid_token")
  end

  test "should not authorize an expired token" do
    user = UserFactory.build_user!()
    token = Auth.create_token(user, -1)
    assert {:error, "Expired token"} = Auth.authorize(token)
  end
end
