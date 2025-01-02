defmodule Redezvous.Models.Event do
  use Ecto.Schema
  alias Redezvous.Models.User

  @moduledoc """
  Documentation for Event.
  """
  schema "event" do
    field :title, :string
    field :description, :string
    field :date, :utc_datetime
    field :location, :string
    field :finished, :boolean
    field :cancelled, :boolean

    belongs_to :created_by, User

    timestamps()
  end
end
