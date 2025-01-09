defmodule Redezvous.ManageEvents do
  @moduledoc """
  Documentation for ManageEvents.
  """
  alias Absinthe.Resolution
  alias Redezvous.Helpers.HandlerHelpers
  alias Redezvous.Models.{Event, User}
  alias Redezvous.Repo
  import Ecto.Query

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
      |> update_params_event_with_guests()

    %Event{}
    |> Event.changeset(params)
    |> Repo.insert()
    |> HandlerHelpers.handle_insertion("Event not created")
  end

  def update_params_event_with_guests(params = %{guests: guests}) do
    query =
      from u in User,
        where: u.email in ^guests,
        select: u

    guests_users = Repo.all(query)

    Map.put(params, :guests, guests_users)
  end

  def update_params_event_with_guests(params), do: params |> Map.put(:guests, [])
end
