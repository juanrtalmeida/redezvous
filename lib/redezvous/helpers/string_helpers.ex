defmodule Redezvous.Helpers.StringHelpers do
  @moduledoc """
  This module is responsible for having helper functions to handle strings
  """

  @doc """
  This function is responsible for replacing variables in a string

  Example:
  "should have at least %{count} characters" |> replace_string_variables([count: 3])
  will be converted to:
  "should have at least 3 characters"
  """
  @spec replace_string_variables(String.t(), Keyword.t()) :: String.t()
  def replace_string_variables(msg, validation_variables) when is_list(validation_variables) do
    msg
    |> String.replace(~r/%{(\w+)}/, fn
      "%{" <> rest ->
        key = String.trim_trailing(rest, "}")

        to_string(Keyword.get(validation_variables, key |> String.to_atom(), "%{#{key}}"))
    end)
  end

  @spec create_random_string(integer()) :: String.t()
  def create_random_string(length) do
    for _ <- 1..length, into: "", do: <<Enum.random(?a..?z)>>
  end

  def create_random_email do
    "#{create_random_string(10)}@#{create_random_string(10)}.#{create_random_string(3)}"
  end
end
