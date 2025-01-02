defmodule Redezvous.ManageAccountTest do
  use RedezvousWeb.ConnCase, async: true

  alias Redezvous.ManageAccount

  describe "create_account/1" do
    test "should create an account" do
      assert {:ok, _} =
               ManageAccount.create_new_user(
                 %{name: "John Doe", email: "john@example.com", password: "password"},
                 %{}
               )
    end
  end
end
