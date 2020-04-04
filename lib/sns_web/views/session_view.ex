defmodule SnsWeb.SessionView do
  use SnsWeb, :view

  def render("sign_in.json", %{user: user, jwt: jwt}) do
    %{"token": jwt}
  end

  def render("error.json", %{message: msg}) do
    %{"error": msg}
  end
end
