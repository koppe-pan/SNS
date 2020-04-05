defmodule SnsWeb.Resolvers.Session do
  alias Sns.Repo
  alias Sns.Users.User

  def create(args, _info) do
    user = Repo.get_by(User, phone: args[:phone])

    case authenticate(user, args[:password]) do
      true -> create_token(user)
      _ -> {:error, "User could not be authenticated."}
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _ -> Comeonin.Bcrypt.checkpw(password, user.password_hash)
    end
  end

  defp create_token(user) do
    case Sns.Guardian.encode_and_sign(user) do
      nil -> {:error, "An Error occured creating the token"}
      {:ok, token, _full_claims} -> {:ok, %{token: token}}
    end
  end
end
