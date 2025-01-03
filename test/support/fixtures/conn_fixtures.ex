defmodule RedezvousWeb.Fixtures.ConnFixtures do
  @moduledoc false
  alias Plug.Conn

  alias Redezvous.Auth
  alias Redezvous.UserFactory

  @doc """
  Builds a conn with a valid token and user

  ## Examples

  iex> build_conn_with_valid_token(conn, %{name: "John Doe", email: "john.doe@example.com", password: "password"})
  %Plug.Conn{
    ...
    headers: [{"authorization", "Bearer <token>"}]
  }
  """
  @spec build_conn_with_valid_token(
          Conn.t(),
          %{name: String.t(), email: String.t(), password: String.t()} | nil
        ) :: Conn.t()
  def build_conn_with_valid_token(conn, user_params \\ %{}) do
    user = UserFactory.build_user!(user_params)
    token = Auth.create_token(user)

    conn
    |> Conn.put_req_header("authorization", "Bearer #{token}")
  end

  def build_conn_with_expired_token(conn) do
    user = UserFactory.build_user!()
    token = Auth.create_token(user, -1)

    conn
    |> Conn.put_req_header("authorization", "Bearer #{token}")
  end
end
