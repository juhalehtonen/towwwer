defmodule PerfMon.Websites.Domain do
  use Ecto.Schema
  import Ecto.Changeset


  schema "domains" do
    field :name, :string
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(domain, attrs) do
    domain
    |> cast(attrs, [:name, :token])
    |> validate_required([:name, :token])
    |> unique_constraint(:name)
    |> unique_constraint(:token)
  end
end
