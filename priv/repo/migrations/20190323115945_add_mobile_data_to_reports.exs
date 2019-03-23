defmodule Towwwer.Repo.Migrations.AddMobileDataToReports do
  use Ecto.Migration

  def change do
    alter table(:reports) do
      add :mobile_data, :map
    end
  end
end
