defmodule Towwwer.Repo.Migrations.UpdateReportsTable do
  use Ecto.Migration

  def change do
    alter table(:reports) do
      add :wpscan_data, :map
    end
  end
end
