defmodule RedezvousWeb.Middlewares.AuthMiddleware do
  @moduledoc """
  Middleware to check if the user has the context of authentication
  """

  @behaviour Absinthe.Middleware

  def call(%{context: %{current_user: _}} = resolution, _) do
    resolution
  end

  def call(resolution, _) do
    resolution |> Absinthe.Resolution.put_result({:error, "Unauthorized"})
  end
end
