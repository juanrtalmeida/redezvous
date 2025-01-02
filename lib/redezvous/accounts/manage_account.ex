defmodule Redezvous.ManageAccount do
  alias Bcrypt
  alias Redezvous.Models.User
  alias Redezvous.Repo
  alias Redezvous.Helpers.ChangesetHelper

  @moduledoc """
  This module is responsible for managing the account of the user

  The managing of account includes the creation of a new user, the updating of a user, and the deletion of a user
  """

  @doc """

  """
  @spec create_new_user(
          %{name: String.t(), email: String.t(), password: String.t()},
          Absinthe.Resolution.t(%{context: %{current_user: User.t()}})
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
    |> handle_user_insertion()
  end

  @doc """
  This function is responsible for creating a new user in the database
  It returns a changeset if the user is not created
  It returns a user if the user is created

  It also hashes the password of the user
  """
  @spec create_user(%{name: String.t(), email: String.t(), password: String.t()}) ::
          Ecto.Changeset.t() | User.t()
  def create_user(params) do
    params
    |> User.changeset()
    |> Map.put(:password, Bcrypt.hash_pwd_salt(params.password))
    |> Repo.insert()
  end

  def handle_user_insertion({:ok, _user} = result), do: result

  def handle_user_insertion({:error, changeset}),
    do:
      {:error,
       %{
         message: "User not created",
         errors: changeset |> ChangesetHelper.convert_changeset_erros_to_json()
       }}
end
