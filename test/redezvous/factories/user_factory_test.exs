defmodule Redezvous.UserFactoryTest do
  use RedezvousWeb.ConnCase, async: true
  alias Redezvous.UserFactory

  test "should create a user with default params" do
    user = UserFactory.build_user!()
    assert user.name == "test test"
    assert user.email == "test@test.com"
    assert is_binary(user.password)
  end

  test "should create a user with custom params" do
    user =
      UserFactory.build_user!(%{
        email: "john_doe@example.com",
        password: "password2",
        name: "john doe"
      })

    assert user.name == "john doe"
    assert user.email == "john_doe@example.com"
    assert is_binary(user.password)
  end

  test "should raise an error if the user is not created" do
    assert_raise RuntimeError, fn ->
      UserFactory.build_user!(%{email: "invalid_email", password: "password", name: "test"})
    end
  end
end
