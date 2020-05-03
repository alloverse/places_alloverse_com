defmodule PlacesAlloverseCom.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias PlacesAlloverseCom.Accounts.Credential
  alias PlacesAlloverseCom.Place

  schema "users" do
    field :name, :string
    field :username, :string
    has_one :credential, Credential
    has_many :places, Place

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> unique_constraint(:username)
  end
end
