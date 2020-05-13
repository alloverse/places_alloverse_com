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

  pipeline :place_checks do
    plug :ensure_authenticated_user
    # plug :ensure_user_owns_place
  end

  scope "/place", PlacesAlloverseComWeb do
    pipe_through [:browser, :place_checks]

    resources "/", PlaceController, only: [:new, :create, :delete, :edit]

  end

  scope "/", PlacesAlloverseComWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/place", PlaceController, only: [:show, :index]
    resources "/user", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete],
                                              singleton: true
    get "/login", UserController, :login
    get "/forgot-password", UserController, :forgot_password

  end

  defp ensure_authenticated_user(conn, _) do
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
