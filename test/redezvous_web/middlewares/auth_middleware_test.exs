defmodule Redezvous.AuthMiddlewareTest do
  use RedezvousWeb.ConnCase, async: true

  alias RedezvousWeb.Middlewares.AuthMiddleware
  alias Redezvous.UserFactory
  alias Absinthe.Resolution

  test "should authorized if current_user is present" do
    user = UserFactory.build_user!()
    context = %{current_user: user}
    resolution = %Resolution{context: context, errors: []}
    result = AuthMiddleware.call(resolution, nil)
    assert result.context == context
  end

  test "should not authorized if current_user is not present" do
    context = %{current_user: nil}
    resolution = %Resolution{context: context, errors: []}
    result = AuthMiddleware.call(resolution, nil)
    assert result.errors == ["Unauthorized"]
  end

  test "should not authorized if expired is true" do
    context = %{expired: true}
    resolution = %Resolution{context: context, errors: []}
    result = AuthMiddleware.call(resolution, nil)
    assert result.errors == ["Unauthorized", "Expired token"]
  end
end
