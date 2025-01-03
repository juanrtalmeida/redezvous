defmodule Redezvous.Models.Event do
  use Ecto.Schema
  alias Redezvous.Models.User

  @moduledoc """
  Documentation for Event.
  """

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "events" do
    field :title, :string
    field :description, :string
    field :date, :utc_datetime
    field :location, :string
    field :finished, :boolean
    field :cancelled, :boolean

    belongs_to :created_by, User, foreign_key: :created_by_id

    timestamps()
  end
end
