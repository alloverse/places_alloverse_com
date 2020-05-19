defmodule PlacesAlloverseCom.Places do
  @moduledoc """
  The Places context.
  """

  import Ecto.Query, warn: false
  alias PlacesAlloverseCom.Repo

  alias PlacesAlloverseCom.Places.Place
  alias PlacesAlloverseCom.Accounts.User


  def list_recommended_places do
      Repo.all(from p in Place, where: p.recommended == true, limit: 3)
      |> Repo.preload(:user)
  end

  def list_public_places do
      Repo.all(from p in Place, where: p.public == true, limit: 3)
      |> Repo.preload(:user)
  end

  def list_my_places(%User{} = user) do
    Repo.all(from p in Place, where: p.user_id ==^ user.id)
    |> Repo.preload(:user)
  end

  def get_place!(id) do
    Place
      |> Repo.get!(id)
      |> Repo.preload(:user)
  end


  def create_place(%User{} = user, attrs \\ %{}) do
    %Place{}
    |> Place.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Repo.insert()
  end

  def change_place(%Place{} = place) do
    Place.changeset(place, %{})
  end

  def update_place(%Place{} = place, attrs) do
    place
    |> Place.changeset(attrs)
    |> Repo.update()
  end


end
