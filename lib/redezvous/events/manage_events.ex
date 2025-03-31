defmodule Redezvous.ManageEvents do
  @moduledoc """
  Documentation for ManageEvents.
  """
  alias Absinthe.Resolution
  alias Redezvous.Helpers.HandlerHelpers
  alias Redezvous.Models.{Event, User}
  alias Redezvous.Repo
  alias Absinthe.Subscription
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
    |> maybe_broadcast_event_created()
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

  @spec update_event(%{id: String.t()} | map(), %Resolution{context: %{current_user: User.t()}}) ::
          {:ok, Event.t()} | {:error, map()}
  def update_event(
        %{id: event_id} = params,
        _context = %Resolution{context: %{current_user: user = %User{}}}
      ) do
    case Repo.get(Event, event_id) do
      nil ->
        {:error, message: "Event not found"}

      event = %Event{created_by_id: user_id} when user_id == user.id ->
        params = 
          params
          |> maybe_update_with_guests()

        changeset = Event.changeset(event, params)

        result = 
          changeset
          |> Repo.update()
          |> HandlerHelpers.handle_insertion("Event not updated")

        case result do
          {:ok, updated_event} = success ->
            # Broadcast the event update
            Subscription.publish(
              RedezvousWeb.Endpoint,
              updated_event,
              event_updated: "event_updated:#{updated_event.id}"
            )
            success
          error -> error
        end

      _event ->
        {:error, message: "You are not authorized to update this event"}
    end
  end

  defp maybe_update_with_guests(%{guests: _} = params), do: update_params_event_with_guests(params)
  defp maybe_update_with_guests(params), do: params

  defp maybe_broadcast_event_created({:ok, event} = result) do
    # We don't broadcast new events since that would require a separate subscription topic
    # But we could easily add it if needed
    result
  end
  defp maybe_broadcast_event_created(error), do: error

  def join_event(params, _context = %Resolution{context: %{current_user: user = %User{}}}) do
    case Repo.get(Event, params.id) do
      nil ->
        {:error, message: "Event not found"}

      event ->
        {:ok, event |> Map.put(:guests, [user | event.guests]) |> Repo.update()}
    end
  end
end
