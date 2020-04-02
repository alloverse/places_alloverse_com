defmodule PlacesAlloverseComWeb.Router do
  use PlacesAlloverseComWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PlacesAlloverseComWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/place", PlaceController
    resources "/user", UserController, only: [:show, :edit, :new]
    get "/login", UserController, :login
    get "/forgot-password", UserController, :forgot_password

  end

  # Other scopes may use custom stacks.
  # scope "/api", PlacesAlloverseComWeb do
  #   pipe_through :api
  # end
end
