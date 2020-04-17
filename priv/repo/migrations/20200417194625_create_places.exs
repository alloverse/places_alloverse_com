defmodule PlacesAlloverseCom.Repo.Migrations.CreatePlaces do
  use Ecto.Migration

  def change do
    create table(:places) do
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
