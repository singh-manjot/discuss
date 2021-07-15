defmodule Discuss.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :token, :string
      add :provider, :string

      # add last updated and creation date  info
      timestamps()
    end
  end
end
