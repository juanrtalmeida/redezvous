defmodule Redezvous.EventFactory do
  @moduledoc """
  Documentation for EventFactory.
  """
  alias Absinthe.Resolution
  alias Redezvous.ManageEvents
  alias Redezvous.Models.Event
  alias Redezvous.UserFactory

  @default_params %{
    title: "test",
    description: "test",
    location: "test"
  }

  @spec build_event!(
          User.t() | nil,
          %{title: String.t(), description: String.t(), date: String.t(), location: String.t()}
        ) :: Event.t() | no_return
  def build_event!(user \\ UserFactory.build_user!(), params \\ %{}) do
    @default_params
    |> Map.merge(params)
    |> ManageEvents.create_new_event(%Resolution{context: %{current_user: user}})
    |> case do
      {:ok, event = %Event{}} -> event
      {:error, changeset} -> raise "Event not created: #{inspect(changeset)}"
    end
  end
end
