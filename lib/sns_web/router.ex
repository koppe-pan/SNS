defmodule SnsWeb.Router do
  use SnsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SnsWeb do
    pipe_through :api
  end
end
