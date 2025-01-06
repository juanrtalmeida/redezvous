defmodule Redezvous.ManageAccount do
  alias Bcrypt
  alias Redezvous.Models.User
  alias Redezvous.Repo
  alias Redezvous.Helpers.HandlerHelpers

  @moduledoc """
  This module is responsible for managing the account of the user

  The managing of account includes the creation of a new user, the updating of a user, and the deletion of a user
  """

  @doc """

  """
  @spec create_new_user(
          %{name: String.t(), email: String.t(), password: String.t()},
          %Absinthe.Resolution{context: %{current_user: User.t()}}
        ) ::
          {:ok, User.t()}
          | {:error,
             %{
               message: String.t(),
               errors: map()
             }}
  def create_new_user(params, _contexts) do
    params
    |> create_user()
    |> HandlerHelpers.handle_insertion("User not created")
  end

  @doc """
  This function is responsible for creating a new user in the database
  It returns a changeset if the user is not created
  It returns a user if the user is created

  It also hashes the password of the user
  """
  @spec create_user(%{name: String.t(), email: String.t(), password: String.t()}) ::
          {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(params) do
    params
    |> User.changeset()
    |> Ecto.Changeset.put_change(:password, Bcrypt.hash_pwd_salt(params.password))
    |> Repo.insert()
  end
end
