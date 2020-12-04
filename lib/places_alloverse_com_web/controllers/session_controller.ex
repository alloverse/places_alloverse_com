defmodule PlacesAlloverseComWeb.SessionController do
  use PlacesAlloverseComWeb, :controller

  alias PlacesAlloverseCom.Accounts
  alias PlacesAlloverseComWeb.UserAuth

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.login_user(conn, user, user_params)
    else
      conn
        |> put_flash(:error, "Invalid e-mail or password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.logout_user()
  end
end
