defmodule PlacesAlloverseCom.Repo.Migrations.AddRecommendedToPlaces do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :recommended, :boolean, default: false, null: false
    end


  end
end
