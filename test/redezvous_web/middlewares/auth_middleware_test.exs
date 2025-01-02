defmodule Redezvous.AuthMiddlewareTest do
  use RedezvousWeb.ConnCase, async: true

  alias RedezvousWeb.Middlewares.AuthMiddleware
  alias Redezvous.UserFactory

  test "should authorized if current_user is present", %{conn: conn} do
    user = UserFactory.build_user!()
    context = %{current_user: user}
    resolution = Absinthe.Plug.put_options(conn, context: context) |> Map.put(:errors, [])
    result = AuthMiddleware.call(resolution, nil)
    assert result.private.absinthe.context == context
  end

  test "should not authorized if current_user is not present", %{conn: conn} do
    context = %{current_user: nil}
    resolution = Absinthe.Plug.put_options(conn, context: context) |> Map.put(:errors, [])
    result = AuthMiddleware.call(resolution, nil)
    assert result.errors == ["Unauthorized"]
  end

  test "should not authorized if expired is true", %{conn: conn} do
    context = %{expired: true}
    resolution = Absinthe.Plug.put_options(conn, context: context) |> Map.put(:errors, [])
    result = AuthMiddleware.call(resolution, nil)
    assert result.errors == ["Unauthorized", "Expired token"]
  end
end
