defmodule Sns.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sns.Repo
  alias Sns.Users.User

  schema "users" do
    field :is_admin, :boolean, default: false
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :phone, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :phone, :password, :is_admin])
    |> validate_required([:name, :phone, :password, :is_admin])
    |> unique_constraint(:phone)
    |> validate_changeset
  end

  defp validate_changeset(user) do
    user
    |> validate_length(:password, min: 8)
    |> validate_format(:password, ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).*/,
      message: "Must include at least one lowercase letter, one uppercase letter, and one digit"
    )
    |> generate_password_hash
  end

  defp generate_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))

      _ ->
        changeset
    end
  end

  def find_and_confirm_password(phone, password) do
    case Repo.get_by(User, phone: phone) do
      nil ->
        {:error, :not_found}

      user ->
        if Comeonin.Bcrypt.checkpw(password, user.password_hash) do
          {:ok, user}
        else
          {:error, :unauthorized}
        end
    end
  end
end
