defmodule Towwwer.Repo.Migrations.AddSiteWpContentDir do
  use Ecto.Migration

  def change do
    alter table(:sites) do
      add :wp_content_dir, :string, default: "wp-content"
      add :wp_plugins_dir, :string, default: "wp-content/plugins"
    end
  end
end
