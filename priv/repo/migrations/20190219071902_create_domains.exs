defmodule PerfMon.Repo.Migrations.CreateDomains do
  use Ecto.Migration

  def change do
    create table(:domains) do
      add :name, :string
      add :token, :string

      timestamps()
    end

    create unique_index(:domains, [:name])
    create unique_index(:domains, [:token])
  end
end
