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

  def new(conn, _params) do
    changeset = Places.change_place(%Place{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"place" => place_params}) do
    case Places.create_place(conn.assigns.current_user, place_params) do
      {:ok, place} ->
        conn
        |> put_flash(:info, "Place created successfully.")
        |> redirect(to: Routes.place_path(conn, :show, place))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    render(conn, "edit.html", id: id)
  end

end
