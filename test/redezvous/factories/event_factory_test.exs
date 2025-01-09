defmodule Redezvous.EventFactoryTest do
  @moduledoc false
  use RedezvousWeb.ConnCase, async: true
  alias Redezvous.EventFactory
  alias Redezvous.UserFactory

  test "should be create an event for the given user" do
    event =
      UserFactory.build_user!(%{name: "not default user", email: "not_default_email@example.com"})
      |> EventFactory.build_event!(%{title: "test", description: "test", location: "test"})

    assert event.title == "test"
    assert event.description == "test"
    assert event.date == nil
    assert event.location == "test"
    assert event.created_by.name == "not default user"
    assert event.created_by.email == "not_default_email@example.com"
  end

  test "should be create an event for the default user" do
    event =
      UserFactory.build_user!()
      |> EventFactory.build_event!(%{title: "test", description: "test", location: "test"})

    assert event.title == "test"
    assert event.description == "test"
    assert event.date == nil
    assert event.location == "test"
    assert event.created_by.name == "test test"
    assert event.created_by.email == "test@test.com"
  end

  test "should be create an event with a given date" do
    event =
      UserFactory.build_user!()
      |> EventFactory.build_event!(%{title: "test", description: "test", date: "2022-01-01T00:00:00Z", location: "test"})

    assert event.title == "test"
    assert event.description == "test"
    assert event.location == "test"
    assert event.created_by.name == "test test"
    assert event.date == ~U[2022-01-01 00:00:00Z]
    assert event.created_by.email == "test@test.com"
  end

  test "should raise an error if the event is not created with and invalid date" do
    assert_raise RuntimeError, fn ->
      UserFactory.build_user!()
      |> EventFactory.build_event!(%{title: "test", description: "test", date: "2022-01-01", location: "test"})
    end
  end

  test "should create event with given guests" do
    user1 = UserFactory.build_user!()
    user2 = UserFactory.build_user!(%{email: "example2@gmail.com"})

    event =
      UserFactory.build_user!(%{email: "real_test@test.com", name: "real test"})
      |> EventFactory.build_event!(%{title: "test", description: "test", date: "2022-01-01T00:00:00Z", location: "test", guests: [user1.email, user2.email]})

    assert event.guests == [user1, user2]
    assert event.created_by.name == "real test"
  end
end
