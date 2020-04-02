defmodule PlacesAlloverseComWeb.PlaceController do
  use PlacesAlloverseComWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", id: id)
  end

  def new(conn, _params) do
    render(conn, "edit.html")
  end

  def edit(conn, %{"id" => id}) do
    render(conn, "edit.html", id: id)
  end

end
