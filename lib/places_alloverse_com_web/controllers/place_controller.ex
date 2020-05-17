defmodule PlacesAlloverseComWeb.PlaceController do
  use PlacesAlloverseComWeb, :controller

  alias PlacesAlloverseCom.Places
  alias PlacesAlloverseCom.Places.Place


  def index(conn, _params) do

    my_places = case Map.fetch(conn.assigns, :current_user ) do
      :error -> []
      {:ok, current_user} -> Places.list_my_places(current_user)
    end

    render(conn, "index.html", my_places: my_places)
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
    place = Places.get_place!(id)

    changeset = Places.change_place(place)
    render(conn, "edit.html", place: place, changeset: changeset)
  end

  def update(conn, %{"id" => id, "place" => place_params}) do
    place = Places.get_place!(id)

    case Places.update_place(place, place_params) do
      {:ok, place} ->
        conn
        |> put_flash(:info, "Place updated successfully.")
        |> redirect(to: Routes.place_path(conn, :show, place))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", place: place, changeset: changeset)
    end
  end
end
