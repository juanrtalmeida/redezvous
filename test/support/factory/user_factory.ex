defmodule Redezvous.UserFactory do
  @moduledoc """
  This module is responsible for factorying users for testing
  """

  alias Redezvous.ManageAccount
  alias Redezvous.Models.User

  @default_user_params %{
    email: "test@test.com",
    password: "password",
    name: "test test"
  }

  @doc """
  This function is responsible for creating a user in the database
  It returns a user if the user is created
  It raises an error if the user is not created

  The default user params are:
  - email: "test@test.com"
  - password: "password"
  - name: "test test"

  The params are merged with the default user params

  If your want a user with a different email, you can pass the email as a parameter
  If your want a user with a different password, you can pass the password as a parameter
  If your want a user with a different name, you can pass the name as a parameter

  Example:
  ```
  iex > UserFactory.build_user!(%{email: "test2@test.com", password: "password2", name: "test test2"})
  %Redezvous.Models.User{
    __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
    id: "1234567890",
    email: "test2@test.com",
    password: "password2",
    name: "test test2",
    inserted_at: #DateTime<2021-05-01 10:00:00Z>,
    updated_at: #DateTime<2021-05-01 10:00:00Z>
  }
  ```
  """
  @spec build_user!(%{email: String.t(), password: String.t(), name: String.t()}) :: User.t()
  def build_user!(params \\ %{}) do
    @default_user_params
    |> Map.merge(params)
    |> ManageAccount.create_user()
    |> case do
      {:ok, user} -> user
      {:error, changeset} -> raise "User not created: #{inspect(changeset)}"
    end
  end
end
