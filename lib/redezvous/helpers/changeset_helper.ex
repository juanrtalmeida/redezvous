defmodule Redezvous.Helpers.ChangesetHelper do
  @moduledoc """
  This module is responsible for having helper functions to handle changesets
  """

  alias Redezvous.Helpers.StringHelpers

  @doc """
  This function is responsible for converting changeset errors to a JSON format
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
