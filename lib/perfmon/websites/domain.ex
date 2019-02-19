defmodule PerfMon.Websites.Domain do
  use Ecto.Schema
  import Ecto.Changeset
  alias PerfMon.Websites.Monitor

  schema "domains" do
    field :name, :string
    field :token, :string
    has_many :monitors, Monitor

    timestamps()
  end

  @doc false
  def changeset(domain, attrs) do
    domain
    |> cast(attrs, [:name, :token])
    |> cast_assoc(:monitors, required: true)
    |> validate_required([:name, :token])
    |> unique_constraint(:name)
    |> unique_constraint(:token)
  end
end
