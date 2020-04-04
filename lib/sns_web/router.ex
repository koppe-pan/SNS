defmodule SnsWeb.Router do
  use SnsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Sns.Guardian.AuthPipeline
  end

  scope "/api", SnsWeb do
    pipe_through :api
    post "/sign_in", SessionController, :sign_in
    resources "/users", UserController, only: [:create]

    pipe_through :authenticated
    resources "/users", UserController, except: [:new, :create, :edit]
  end
end
