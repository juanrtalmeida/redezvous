defmodule Redezvous.Users do
  alias Absinthe.Resolution
  alias Redezvous.Models.User
  alias Redezvous.Repo

  @moduledoc """
  This module should handle queries and mutations related to users
  """

  @doc """
  def user_infos(args, params, contexts) :: {:ok, User} | {:error, Ecto.Changeset}
  Returns informations of an user

  ## Examples

      iex> user_infos(args, params, contexts)
      {:ok, %User{}}

      iex> user_infos(args, params, contexts)
      {:error, %Ecto.Changeset{}}


  """
  @spec user_infos(
          %{},
          %Resolution{context: %{current_user: User.t()}}
        ) :: {:ok, list()}
  def user_infos(_, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end
end
