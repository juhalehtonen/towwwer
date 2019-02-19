defmodule PerfMon.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :data, :map
      add :monitor_id, references(:monitors, on_delete: :nothing)

      timestamps()
    end

    create index(:reports, [:monitor_id])
  end
end
