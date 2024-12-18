defmodule Redezvous do
  @moduledoc """
  Redezvous keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc """
  def user_infos(params, contexts)

    This function should return the user infos

    The contexts can be of the following types:

    - With context searching for the user own infos
        - Should return the user infos

  """
  defdelegate user_infos(params, contexts), to: Redezvous.Users

  @doc """
  def create_login_token(params, contexts)

    This function should return the login token using the email and password
    if the user exists and the password is correct for the given email
  """

  defdelegate create_login_token(params, contexts), to: Redezvous.Auth, as: :login

  defdelegate create_new_user(params, contexts), to: Redezvous.Users
end
