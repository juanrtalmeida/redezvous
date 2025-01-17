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

  @doc """
  def create_new_user(params, contexts)

    This function should create a new user for the application
  """

  defdelegate create_new_user(params, contexts), to: Redezvous.ManageAccount

  @doc """
  def list_created_votes(params, contexts)

    This function should return the list of votes created by the user
  """
  defdelegate list_created_votes(params, contexts), to: Redezvous.Accounts.AccountFieldsResolvers

  @doc """
  def list_created_suggestions(params, contexts)

    This function should return the list of suggestions created by the user
  """
  defdelegate list_created_suggestions(params, contexts), to: Redezvous.Accounts.AccountFieldsResolvers

  @doc """
  def list_created_events(params, contexts)

    This function should return the list of events created by the user
  """
  defdelegate list_created_events(params, contexts), to: Redezvous.Accounts.AccountFieldsResolvers

  @doc """
  def create_new_event(params, contexts)

    This function should create a new event
  """

  defdelegate create_new_event(params, contexts), to: Redezvous.ManageEvents

  @doc """
  def get_event_infos(params, contexts)

    This function should return the event infos
  """
  defdelegate get_event_infos(params, contexts), to: Redezvous.Events.EventFieldsResolver

  @doc """
  def list_guests(params, contexts)

    This function should return the list of guests

  """
  defdelegate list_guests(parent, params, contexts), to: Redezvous.Events.EventFieldsResolver

  defdelegate event_created_by(parent, params, contexts), to: Redezvous.Events.EventFieldsResolver

  defdelegate create_new_suggestion(params, contexts), to: Redezvous.Suggestion.ManageSuggestions

  defdelegate list_suggestions(parent, params, contexts), to: Redezvous.Suggestion.ManageSuggestions

  defdelegate create_new_vote(params, contexts), to: Redezvous.Vote.ManageVotes

  defdelegate list_votes(parent, params, contexts), to: Redezvous.Vote.VotesFieldsResolvers
end
