defmodule PerfMon.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :base_url, :string
      add :token, :string

      timestamps()
    end

    create unique_index(:sites, [:base_url])
    # create unique_index(:sites, [:token])
  end
end
