defmodule PlacesAlloverseCom.Repo.Migrations.CreatePlaces do
  use Ecto.Migration

  def change do
    create table(:places) do
      add :name, :string
      add :description, :text
      add :public, :boolean, default: false, null: false
      add :user_id, references(:users),
                    null: false

      timestamps()
    end

    create index(:places, [:user_id])

  end
end
