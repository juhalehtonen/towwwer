defmodule PerfMon.Repo.Migrations.CreateMonitors do
  use Ecto.Migration

  def change do
    create table(:monitors) do
      add :path, :string
      add :domain_id, references(:domains, on_delete: :nothing)

      timestamps()
    end

    create index(:monitors, [:domain_id])
  end
end
