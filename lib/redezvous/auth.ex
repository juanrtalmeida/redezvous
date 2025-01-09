defmodule Redezvous.Auth do
  @moduledoc false
  @salt System.get_env("SALT") || "salt"
  alias Phoenix.Token
  alias Redezvous.Models.User
  alias Redezvous.Users
  alias RedezvousWeb.Endpoint

  @doc """
  def login(email, password) :: {:ok, String.t} | {:error, String.t}

  Logs in a user with the given email and password.

  Usage:

    iex> Auth.login("email", "password")
    {:ok, "token"}

    iex> Auth.login("email", "wrong_password")
    {:error, "Invalid password"}
  """
  @spec login(map(), map()) :: {:ok, binary()} | {:error, binary()}
  def login(%{email: email, password: password}, _) do
    Users.get_user_by_email(email)
    |> handle_user_search()
    |> validate_password(password)
  end

  @spec handle_user_search(nil | User.t()) :: {:error, binary()} | {User.t()}
  defp handle_user_search(nil), do: {:error, "User not found"}
  defp handle_user_search(user = %User{}), do: user

  @spec validate_password({:error, binary()} | User.t(), binary()) :: {:ok, binary()} | {:error, binary()}
  defp validate_password(user = %User{password: user_password}, password) do
    Bcrypt.verify_pass(password, user_password) |> handle_password_verification(user)
  end

  defp validate_password(error = {:error, "User not found"}, _pass), do: error

  @spec handle_password_verification(boolean(), User.t()) :: {:ok, binary()} | {:error, binary()}
  defp handle_password_verification(false, _), do: {:error, "Invalid password"}
  defp handle_password_verification(true, user = %User{}), do: {:ok, create_token(user)}

  @doc """
  def verify_token(token) :: {:ok, user_id} | {:error, String.t}

  Verifies the given token and returns the user if the token is valid.

  Usage:

      iex> AuthContext.verify_token("token")
      {:ok, %User{}}

      iex> AuthContext.verify_token("invalid_token")
      {:error, "Invalid token"}

      iex> AuthContext.verify_token("expired_token")
      {:error, "Expired token"}
  """
  @spec authorize(binary()) :: {:ok, User.t()} | {:error, binary()}
  def authorize(token) do
    case Token.verify(Endpoint, @salt, token) do
      {:ok, user} -> {:ok, user}
      {:error, :expired} -> {:error, "Expired token"}
      _ -> {:error, "Invalid token"}
    end
  end

  @doc """
   def create_token(user) :: User.t()

   generates a token for the given user
  """
  @spec create_token(User.t(), integer() | 86_400) :: binary()
  def create_token(user = %User{}, max_age \\ 86_400) do
    Token.sign(Endpoint, @salt, user, [{:max_age, max_age}])
  end
end
