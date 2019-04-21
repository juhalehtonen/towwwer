defmodule Towwwer.Websites.Site do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Towwwer.Websites.Monitor

  schema "sites" do
    field :base_url, :string
    field :token, :string
    field :wp_content_dir, :string, default: "wp-content"
    field :wp_plugins_dir, :string, default: "wp-content/plugins"
    has_many :monitors, Monitor

    timestamps()
  end

  @doc false
  def changeset(site, attrs \\ %{}) do
    site
    |> cast(attrs, [:base_url, :token, :wp_plugins_dir, :wp_content_dir])
    |> cast_assoc(:monitors, required: true)
    |> validate_required([:base_url, :token, :wp_plugins_dir, :wp_content_dir])
    |> unique_constraint(:base_url)
  end
end
