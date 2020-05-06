defmodule PlacesAlloverseCom.Places do
  @moduledoc """
  The Places context.
  """

  import Ecto.Query, warn: false
  alias PlacesAlloverseCom.Repo

  alias PlacesAlloverseCom.Places.Place

  def list_places do
    Place
      |> Repo.all()
  end

  def list_my_places do
    Place
      |> Repo.all()
  end

  def list_recommended_places do
    Place
      |> Repo.all()
  end

  def list_public_places do
    Place
      |> Repo.all()
  end

  def get_place!(id) do
    Place
      |> Repo.get!(id)
      |> Repo.preload(:user)
  end


  def create_place(attrs \\ %{}) do
    %Place{}
    |> Place.changeset(attrs)
    |> Repo.insert()
  end


end
