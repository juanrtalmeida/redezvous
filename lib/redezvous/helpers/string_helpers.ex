defmodule Redezvous.Helpers.StringHelpers do
  @moduledoc """
  This module is responsible for having helper functions to handle strings
  """

  @doc """
  This function is responsible for replacing variables in a string
  """
  @spec replace_string_variables(String.t(), Keyword.t()) :: String.t()
  def replace_string_variables(msg, validation_variables) when is_list(validation_variables) do
    msg
    |> String.replace(~r/%{(\w+)}/, fn
      "%{" <> rest ->
        key = String.trim_trailing(rest, "}")

        to_string(Keyword.get(validation_variables, key |> String.to_atom()))
    end)
  end
end
