defmodule Redezvous.Auth do
  @salt System.get_env("SALT")
  alias Redezvous.Users
  alias Phoenix.Token
  alias RedezvousWeb.Endpoint
  alias Redezvous.Models.User

  @doc """
  def login(email, password) :: {:ok, String.t} | {:error, String.t}

  Logs in a user with the given email and password.

  Usage:

    iex> Auth.login("email", "password")
    {:ok, "token"}

    iex> Auth.login("email", "wrong_password")
    {:error, "Invalid password"}
  """
  @spec login(binary(), binary()) :: {:ok, binary()} | {:error, binary()}
  def login(email, password) do
    Users.get_user_by_email(email)
    |> handle_user_search()
    |> validate_password(password)
  end

  @spec handle_user_search(nil | User.t()) :: {:error, binary()} | {User.t()}
  defp handle_user_search(nil), do: {:error, "User not found"}
  defp handle_user_search(%User{} = user), do: user

  @spec validate_password({:error, binary()} | {:ok, binary()}, binary()) :: {:ok, binary()} | {:error, binary()}
  defp validate_password({:error, "User not found"} = error, _pass), do: error

  @spec validate_password(User.t(), binary()) :: {:ok, binary()} | {:error, binary()}
  defp validate_password(%User{password: user_password} = user, password) do
    Bcrypt.verify_pass(password, user_password) |> handle_password_verification(user)
  end

  @spec handle_password_verification(boolean, User.t()) :: {:ok, binary()} | {:error, binary()}
  defp handle_password_verification(false, _), do: {:error, "Invalid password"}
  defp handle_password_verification(true, %User{} = user), do: {:ok, create_token(user)}

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
  @spec create_token(User.t(), integer()) :: binary()
  def create_token(%User{} = user, max_age \\ 86_400) do
    Token.sign(Endpoint, @salt, user, [{:max_age, max_age}])
  end
end
