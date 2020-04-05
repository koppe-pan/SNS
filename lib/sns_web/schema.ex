defmodule SnsWeb.Schema do
  use Absinthe.Schema
  import_types(SnsWeb.Schema.AccountTypes)
  import_types(SnsWeb.Schema.SessionTypes)

  alias SnsWeb.Resolvers

  query do
    @desc "Get all users"
    field :users, list_of(:user) do
      resolve(&Resolvers.Accounts.list_users/3)
    end

    @desc "Get a user by id"
    field :user, :user do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Accounts.get_user/3)
    end

    @desc "Get current app user"
    field :current_user, :user do
      resolve(&Resolvers.Accounts.current_user/2)
    end
  end

  mutation do
    @desc "Create a user"
    field :create_user, :user do
      arg(:name, non_null(:string))
      arg(:phone, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Accounts.create_user/3)
    end

    @desc "Login User"
    field :session, :token do
      arg(:phone, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Session.create/2)
    end
  end
end
