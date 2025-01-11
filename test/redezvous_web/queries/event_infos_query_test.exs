defmodule Redezvous.EventInfosQueryTest do
  @moduledoc false
  use RedezvousWeb.ConnCase, async: true

  test "should return event infos correctly for the given id", %{conn: conn} do
    event = Redezvous.EventFactory.build_event!()

    query = """
    query {
    eventInfos(eventId:"#{event.id}"){
     cancelled,
     createdBy {
       email,id,name
     },
     date,
     description,
     finished,
     guests {
       name,id,email
     },
     location
    }
    }
    """

    conn = post(conn, "/", %{query: query})
    response = json_response(conn, 200)

    assert %{
             "data" => %{
               "eventInfos" => %{
                 "cancelled" => result_cancelled,
                 "createdBy" => %{
                   "email" => result_created_by_email,
                   "id" => result_created_by_id,
                   "name" => result_created_by_name
                 },
                 "date" => result_date,
                 "description" => result_description,
                 "finished" => result_finished,
                 "guests" => result_guests,
                 "location" => result_location
               }
             }
           } = response

    assert event.cancelled == result_cancelled
    assert event.created_by.email == result_created_by_email
    assert event.created_by.id == result_created_by_id
    assert event.created_by.name == result_created_by_name
    assert event.date == result_date
    assert event.description == result_description
  end

  test "should return event infos correctly for the given id with guests", %{conn: conn} do
    guest1 = Redezvous.UserFactory.build_user!(%{email: "guest1@example.com"})
    guest2 = Redezvous.UserFactory.build_user!(%{email: "guest2@example.com"})
    user = Redezvous.UserFactory.build_user!()
    event = Redezvous.EventFactory.build_event!(user, %{guests: [guest1.email, guest2.email]})

    query = """
    query {
    eventInfos(eventId:"#{event.id}"){
    cancelled,
    createdBy {
      email,id,name
    },
    guests{
      id, name, email
    }
    date,
    description,
    finished,
    location
    }
    }
    """

    conn = post(conn, "/", %{query: query})

    response = json_response(conn, 200)

    assert %{
             "data" => %{
               "eventInfos" => %{
                 "cancelled" => result_cancelled,
                 "createdBy" => %{
                   "email" => result_created_by_email,
                   "id" => result_created_by_id,
                   "name" => result_created_by_name
                 },
                 "date" => result_date,
                 "description" => result_description,
                 "finished" => result_finished,
                 "guests" => result_guests,
                 "location" => result_location
               }
             }
           } = response

    assert event.cancelled == result_cancelled
    assert event.created_by.email == result_created_by_email
    assert event.created_by.id == result_created_by_id
    assert event.created_by.name == result_created_by_name
    assert event.date == result_date
    assert event.description == result_description
    assert event.location == result_location

    [guest1, guest2]
    |> Enum.each(fn guest ->
      assert Enum.any?(result_guests, fn result_guest -> result_guest["email"] == guest.email end)
      assert Enum.any?(result_guests, fn result_guest -> result_guest["id"] == guest.id end)
      assert Enum.any?(result_guests, fn result_guest -> result_guest["name"] == guest.name end)
    end)
  end
end
