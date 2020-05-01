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
    resources "/user", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete],
                                              singleton: true
    get "/login", UserController, :login
    get "/forgot-password", UserController, :forgot_password

  end

  scope "/cms", PlacesAlloverseComWeb.CMS, as: :cms do
    pipe_through [:browser, :authenticate_user]

    resources "/pages", PageController
  end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()
      user_id ->
        assign(conn, :current_user, PlacesAlloverseCom.Accounts.get_user!(user_id))
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", PlacesAlloverseComWeb do
  #   pipe_through :api
  # end
end
