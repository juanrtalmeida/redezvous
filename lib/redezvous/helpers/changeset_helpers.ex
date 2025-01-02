defmodule Redezvous.Helpers.ChangesetHelpers do
  @moduledoc """
  This module is responsible for having helper functions to handle changesets
  """

  alias Redezvous.Helpers.StringHelpers

  @doc """
  This function is responsible for converting changeset errors to a JSON format

  Example:
  Ecto.Changeset.add_error(changeset, "name", "should have at least %{count} characters",
    validation: :length,
    count: 3
  )
  will be converted to:
  %{name: "should have at least 3 characters"}


  Ecto.Changeset%{
  errors: [
    name: {"should have at least %{count} characters", [count: 3]}
  ]
  }
  will be converted to:
  %{name: "should have at least 3 characters"}
  """
  @spec convert_changeset_erros_to_json(Ecto.Changeset.t()) :: map()
  def convert_changeset_erros_to_json(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {msg, validation_variables}} ->
      {field, msg |> StringHelpers.replace_string_variables(validation_variables)}
    end)
    |> Map.new()
  end
end
