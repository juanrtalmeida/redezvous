defmodule RedezvousWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: RedezvousWeb.Schema

  ## Channels
  # channel "room:*", RedezvousWeb.RoomChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  @impl true
  def connect(params, socket, _connect_info) do
    socket = Absinthe.Phoenix.Socket.put_options(socket, context: build_context(params))
    {:ok, socket}
  end

  defp build_context(params) do
    with %{"token" => token} <- params,
         {:ok, user_id} <- verify_token(token),
         {:ok, user} <- get_user(user_id) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end

  defp verify_token(token) do
    # In a real application, you should use a proper token verification method
    # This is just a simplified example
    case Redezvous.Auth.verify_token(token) do
      {:ok, claims} -> {:ok, claims["sub"]}
      _ -> :error
    end
  end

  defp get_user(user_id) do
    case Redezvous.Repo.get(Redezvous.Models.User, user_id) do
      nil -> :error
      user -> {:ok, user}
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     RedezvousWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(_socket), do: nil
end 