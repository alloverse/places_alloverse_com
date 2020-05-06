defmodule PlacesAlloverseComWeb.PlaceController do
  use PlacesAlloverseComWeb, :controller

  alias PlacesAlloverseCom.Places
  alias PlacesAlloverseCom.Places.Place


  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"id" => id}) do
    place = Places.get_place!(id)
    render(conn, "show.html", place: place)
  end

  # Identical to edit, use this one to figure out how to create a place
  def new(conn, _params) do
    render(conn, "new.html")
  end

  def edit(conn, %{"id" => id}) do
    render(conn, "edit.html", id: id)
  end

end
