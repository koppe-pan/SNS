defmodule SnsWeb.Schema.AccountTypes do
  use Absinthe.Schema.Notation

  @desc "a user"
  object :user do
    field :id, :id
    field :name, :string
    field :phone, :string
    field :password_hash, :string
    field :is_admin, :boolean
  end
end
