defmodule RedezvousWeb.SchemaTypes do
  @moduledoc """
  Documentation for SchemaTypes.
  """
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
  end
end
