defmodule Redezvous.StringHelpersTest do
  use RedezvousWeb.ConnCase, async: true
  alias Redezvous.Helpers.StringHelpers

  test "should replace string variables" do
    assert StringHelpers.replace_string_variables("should have at least %{count} characters",
             count: 3
           ) == "should have at least 3 characters"
  end

  test "should not replace string variables if they are not present" do
    assert StringHelpers.replace_string_variables("should have at least %{count} characters",
             something: 3
           ) == "should have at least %{count} characters"
  end
end
