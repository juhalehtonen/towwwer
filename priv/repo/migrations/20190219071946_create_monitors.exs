defmodule Towwwer.Repo.Migrations.CreateMonitors do
  use Ecto.Migration

  def change do
    create table(:monitors) do
      add :path, :string
      add :site_id, references(:sites, on_delete: :delete_all)

      timestamps()
    end

    create index(:monitors, [:site_id])
  end
end
