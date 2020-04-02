defmodule PlacesAlloverseComWeb.UserController do
  use PlacesAlloverseComWeb, :controller

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", id: id)
  end

  def new(conn, _params) do
    render(conn, "edit.html")
  end

  def edit(conn, %{"id" => id}) do
    render(conn, "edit.html", id: id)
  end

  def login(conn, _params) do
    render(conn, "login.html")
  end

  def forgot_password(conn, _params) do
    render(conn, "forgot.html")
  end
end
