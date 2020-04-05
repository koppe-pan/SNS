defmodule SnsWeb.Router do
  use SnsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Sns.Guardian.AuthPipeline
  end

  pipeline :graphql do
    plug Sns.Context
  end

  scope "/api" do
    pipe_through [:api, :graphql]

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: SnsWeb.Schema

    forward "/", Absinthe.Plug, schema: SnsWeb.Schema

    '''
    post "/sign_in", SessionController, :sign_in
    resources "/users", UserController, only: [:create]

    pipe_through :authenticated
    resources "/users", UserController, except: [:new, :create, :edit]
    '''
  end
end
