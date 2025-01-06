defmodule RedezvousWeb.Middlewares.AuthMiddleware do
  @moduledoc """
  Middleware to check if the user has the context of authentication
  """

  @behaviour Absinthe.Middleware

  alias Redezvous.Models.User

  def call(resolution = %Absinthe.Resolution{context: %{current_user: %User{} = _user}}, _) do
    resolution
  end

  def call(resolution = %Absinthe.Resolution{context: %{expired: true}}, _) do
    resolution |> Absinthe.Resolution.put_result({:error, ["Unauthorized", "Expired token"]})
  end

  def call(resolution, _) do
    resolution |> Absinthe.Resolution.put_result({:error, "Unauthorized"})
  end
end
