defmodule RedezvousWeb.Contexts.AuthContext do
  @behaviour Plug

  import Plug.Conn

  alias Redezvous.Auth

  def init(opts), do: opts

  def call(conn, _opts) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header

  ## Examples

      iex> build_context(conn)
      %{current_user: %User{}}

      iex > build_context(conn)
      {:error, "invalid authorization token"}

      @spec build_context(Plug.Conn.t()) :: {:error, String.t()} | %{current_user: User.t()}
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- Auth.authorize(token) do
      %{current_user: current_user}
    else
      _ -> conn |> put_status(:unauthorized) |> halt
    end
  end
end
