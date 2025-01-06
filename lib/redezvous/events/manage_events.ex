defmodule Redezvous.ManageEvents do
  @moduledoc """
  Documentation for ManageEvents.
  """
  alias Redezvous.Helpers.HandlerHelpers
  alias Redezvous.Models.{Event, User}
  alias Absinthe.Resolution
  alias Redezvous.Repo

  @spec create_new_event(
          %{title: String.t(), description: String.t()}
          | %{title: String.t(), description: String.t(), date: String.t(), location: String.t()}
          | %{title: String.t(), description: String.t(), date: String.t(), location: String.t(), date: String.t()},
          %Resolution{context: %{current_user: User.t()}}
        ) ::
          {:ok, Event.t()}
          | {:error,
             %{
               message: String.t(),
               errors: map()
             }}
  def create_new_event(params, _context = %Resolution{context: %{current_user: user = %User{}}}) do
    params =
      Map.put_new(params, :created_by, user)

    %Event{}
    |> Event.changeset(params)
    |> Repo.insert()
    |> HandlerHelpers.handle_insertion("Event not created")
  end
end
