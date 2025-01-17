defmodule Redezvous.Events.EventFieldsResolver do
  @moduledoc """
  Documentation for EventFieldsResolver.
  """
  alias Absinthe.Resolution
  alias Redezvous.Helpers.HandlerHelpers
  alias Redezvous.Models.Event
  alias Redezvous.Repo

  def get_event_infos(params, _context = %Resolution{}) do
    Repo.get(Event, params.event_id)
    |> HandlerHelpers.handle_search()
  end

  def event_created_by(parent, _params, _context = %Resolution{}) do
    parent
    |> Repo.preload(:created_by)
    |> Map.get(:created_by)
    |> HandlerHelpers.handle_search()
  end

  def list_guests(parent, _params, _context = %Resolution{}) do
    parent
    |> Repo.preload(:guests)
    |> Map.get(:guests)
    |> HandlerHelpers.handle_search()
  end
end
