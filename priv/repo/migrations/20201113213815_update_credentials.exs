defmodule PlacesAlloverseCom.Repo.Migrations.UpdateCredentials do
  use Ecto.Migration

  def change do
    alter table(:credentials) do
      add :confirmed_at, :naive_datetime
    end

  end
end
