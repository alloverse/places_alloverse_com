defmodule PlacesAlloverseCom.Repo.Migrations.AddPasswordToCredential do
  use Ecto.Migration

  def change do
    alter table(:credentials) do
      add :password, :string, virtual: true
      add :hashed_password, :string
    end

  end
end
