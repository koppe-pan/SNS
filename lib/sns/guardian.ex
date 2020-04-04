defmodule Sns.Guardian do
  use Guardian, otp_app: :sns

  alias Sns.Repo
  alias Sns.Users.User

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def subject_for_token(_, _) do
    {:error, "unknown resource"}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Repo.get(User, id)
    {:ok, resource}
  end

  def resource_from_claims(_) do
    {:error, "unknown claim"}
  end
end
