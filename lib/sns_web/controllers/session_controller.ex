defmodule SnsWeb.SessionController do
  use SnsWeb, :controller

  alias Sns.Users.User

  def sign_in(conn, %{"session" => %{"phone" => phone, "password" => password}}) do
    case User.find_and_confirm_password(phone, password) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Sns.Guardian.encode_and_sign(user)

        conn
        |> render("sign_in.json", user: user, jwt: jwt)

      {:error, _reason} ->
        conn
        |> put_status(401)
        |> render("error.json", message: "Could not login")
    end
  end
end
