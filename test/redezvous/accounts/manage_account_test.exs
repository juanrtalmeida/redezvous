defmodule Redezvous.ManageAccountTest do
  use RedezvousWeb.ConnCase, async: true

  alias Redezvous.ManageAccount
  alias Redezvous.UserFactory

  test "should create an account" do
    assert {:ok, _} =
             ManageAccount.create_new_user(
               %{name: "John Doe", email: "john@example.com", password: "password"},
               %{}
             )
  end

  test "should not create an account if the email is already taken" do
    UserFactory.build_user!(%{email: "john@example.com"})

    assert {:error, _} =
             ManageAccount.create_new_user(
               %{name: "John Doe", email: "john@example.com", password: "password"},
               %{}
             )
  end

  test "should not create an account if the password is too short" do
    assert {:error, _} =
             ManageAccount.create_new_user(
               %{name: "John Doe", email: "john@example.com", password: "pass"},
               %{}
             )
  end

  test "should not create an account if the name is too short" do
    assert {:error, _} =
             ManageAccount.create_new_user(
               %{name: "Jo", email: "john@example.com", password: "password"},
               %{}
             )
  end

  test "should not create an account if the email is not valid" do
    assert {:error, _} =
             ManageAccount.create_new_user(
               %{name: "John Doe", email: "johnexample.com", password: "password"},
               %{}
             )
  end
end
