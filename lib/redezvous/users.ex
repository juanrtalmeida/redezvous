defmodule Redezvous.Users do
  @moduledoc """
  The Users context.
  """

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(args, two, three) do
    IO.inspect(two)
    {:ok, []}
  end
end
