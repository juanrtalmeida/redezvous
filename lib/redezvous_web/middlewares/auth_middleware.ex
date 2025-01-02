defmodule RedezvousWeb.Middlewares.AuthMiddleware do
  @moduledoc """
  Middleware to check if the user has the context of authentication
  """

  @behaviour Absinthe.Middleware

  alias Redezvous.Models.User

  def call(%Plug.Conn{private: %{absinthe: %{context: %{current_user: %User{} = _user}}}} = conn, _) do
    conn
  end

  def call(%Plug.Conn{private: %{absinthe: %{context: %{expired: true}}}} = resolution, _) do
    resolution |> Absinthe.Resolution.put_result({:error, ["Unauthorized", "Expired token"]})
  end

  def call(resolution, _) do
    resolution |> Absinthe.Resolution.put_result({:error, "Unauthorized"})
  end
end
