defmodule SnsWeb.Resolvers.Accounts do
  def list_users(_parent, _args, _resolution) do
    {:ok, Sns.Users.list_users()}
  end

  def get_user(_parent, %{id: id}, _resolution) do
    case Sns.Users.get_user!(id) do
      nil ->
        {:error, "User ID #{id} not found"}

      user ->
        {:ok, user}
    end
  end

  def create_user(_parent, args, %{context: %{current_user: %{is_admin: false}}}) do
    Sns.Users.create_user(args)
  end

  def create_user(_parent, args, _resolution) do
    {:error, "Access denied"}
  end

  def current_user(_, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def current_user(_, _) do
    {:error, "Access denied"}
  end
end
