defmodule RedezvousWeb.Middlewares.AuthMiddleware do
  @moduledoc """
  Middleware to check if the user has the context of authentication
  """

  @behaviour Absinthe.Middleware

  alias Redezvous.Models.User

  def call(%Absinthe.Resolution{context: %{current_user: %User{} = _user}} = resolution, _) do
    resolution
  end

  def call(%Absinthe.Resolution{context: %{expired: true}} = resolution, _) do
    resolution |> Absinthe.Resolution.put_result({:error, ["Unauthorized", "Expired token"]})
  end

  def call(resolution, _) do
    resolution |> Absinthe.Resolution.put_result({:error, "Unauthorized"})
  end
end
