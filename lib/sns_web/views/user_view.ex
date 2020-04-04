defmodule SnsWeb.UserView do
  use SnsWeb, :view
  alias SnsWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      phone: user.phone,
      password_hash: user.password_hash,
      is_admin: user.is_admin}
  end
end
