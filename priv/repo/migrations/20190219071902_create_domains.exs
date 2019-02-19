defmodule PerfMon.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :name, :string
      add :token, :string

      timestamps()
    end

    create unique_index(:sites, [:name])
    create unique_index(:sites, [:token])
  end
end
