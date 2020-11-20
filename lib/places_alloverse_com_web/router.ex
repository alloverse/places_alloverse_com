defmodule PlacesAlloverseComWeb.Router do
  use PlacesAlloverseComWeb, :router

  import PlacesAlloverseComWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # pipeline :place_checks do
  #   plug :assign_authenticated_user
  #   plug :ensure_authenticated_user
  #   # plug :ensure_user_owns_place
  # end

  scope "/place", PlacesAlloverseComWeb do
    pipe_through [:browser]

    resources "/", PlaceController, only: [:new, :create, :delete, :edit, :update]

  end

  scope "/", PlacesAlloverseComWeb do
    pipe_through [:browser]

    get "/", PageController, :index
    resources "/place", PlaceController, only: [:show, :index, :delete]
    resources "/user", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete],
                                              singleton: true
    get "/login", UserController, :login
    get "/forgot-password", UserController, :forgot_password

  end

  # defp assign_authenticated_user(conn, _) do
  #   case get_session(conn, :user_id) do
  #     nil -> conn
  #     user_id ->
  #       assign(conn, :current_user, PlacesAlloverseCom.Accounts.get_user!(user_id))
  #   end
  # end

  # defp ensure_authenticated_user(conn, _) do
  #   case get_session(conn, :user_id) do
  #     nil ->
  #       conn
  #       |> Phoenix.Controller.put_flash(:error, "Login required")
  #       |> Phoenix.Controller.redirect(to: "/")
  #       |> halt()
  #     _user_id -> conn
  #   end
  # end

  scope "/", PlacesAlloverseComWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]
    # get "/users/register", UserRegistrationController, :new
    # post "/users/register", UserRegistrationController, :create
    get "/users/login", SessionController, :new
    post "/users/login", SessionController, :create
    # get "/users/reset_password", UserResetPasswordController, :new
    # post "/users/reset_password", UserResetPasswordController, :create
    # get "/users/reset_password/:token", UserResetPasswordController, :edit
    # put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", PlacesAlloverseComWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings/update_password", UserSettingsController, :update_password
    put "/users/settings/update_email", UserSettingsController, :update_email
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", PlacesAlloverseComWeb do
    pipe_through [:browser]

    delete "/users/logout", SessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  # Other scopes may use custom stacks.
  # scope "/api", PlacesAlloverseComWeb do
  #   pipe_through :api
  # end
end
