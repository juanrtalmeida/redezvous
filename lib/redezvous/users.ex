defmodule Redezvous.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query
  alias Redezvous.Repo
  alias Redezvous.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(args, _parent, _resolution) do
    query = from(u in User)

    query =
      args
      |> Map.get(:filter, %{})
      |> Enum.reduce(query, fn
        {:name, name}, query -> where(query, [u], ilike(u.name, ^"%#{name}%"))
        {:email, email}, query -> where(query, [u], ilike(u.email, ^"%#{email}%"))
        _, query -> query
      end)

    # We can improve with something dynamic, I need to look futher.

    users =
      query
      |> Repo.all()

    {:ok, users}
  end
end
