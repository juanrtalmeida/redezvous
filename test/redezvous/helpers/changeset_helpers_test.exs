defmodule Redezvous.ChangesetHelpersTest do
  use RedezvousWeb.ConnCase, async: true
  alias Redezvous.Models.User
  alias Redezvous.Helpers.ChangesetHelpers
  alias Ecto.Changeset

  test "should convert changeset errors to json" do
    changeset =
      Changeset.cast(%User{}, %{name: "John"}, [:name])
      |> Changeset.add_error("name", "has invalid format")

    assert changeset |> ChangesetHelpers.convert_changeset_erros_to_json() == %{
             "name" => "has invalid format"
           }
  end

  test "should convert changeset errors to json with multiple errors" do
    changeset =
      Changeset.cast(%User{}, %{name: "John", email: "john@example.com", password: "password"}, [
        :name,
        :email,
        :password
      ])
      |> Changeset.add_error("name", "has invalid format")
      |> Changeset.add_error("email", "has invalid format")
      |> Changeset.add_error("password", "has invalid format")

    assert changeset |> ChangesetHelpers.convert_changeset_erros_to_json() == %{
             "name" => "has invalid format",
             "email" => "has invalid format",
             "password" => "has invalid format"
           }
  end

  test "should convert changeset errors to json with validation variables" do
    changeset =
      Changeset.cast(%User{}, %{name: "John"}, [:name])
      |> Changeset.add_error("name", "should have at least %{count} characters",
        validation: :length,
        count: 3
      )

    assert changeset |> ChangesetHelpers.convert_changeset_erros_to_json() == %{
             "name" => "should have at least 3 characters"
           }
  end
end
