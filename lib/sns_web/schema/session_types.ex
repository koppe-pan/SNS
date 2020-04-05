defmodule SnsWeb.Schema.SessionTypes do
  use Absinthe.Schema.Notation
  @desc "A JWT Token"
  object :token do
    field :token, :string
  end
end
