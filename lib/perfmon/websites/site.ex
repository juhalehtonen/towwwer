defmodule PerfMon.Websites.Site do
  use Ecto.Schema
  import Ecto.Changeset
  alias PerfMon.Websites.Monitor

  schema "sites" do
    field :base_url, :string
    field :token, :string
    has_many :monitors, Monitor

    timestamps()
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [:base_url, :token])
    |> cast_assoc(:monitors, required: true)
    |> validate_required([:base_url, :token])
    |> unique_constraint(:base_url)
    |> unique_constraint(:token)
  end
end
