defmodule PerfMon.Websites.Monitor do
  use Ecto.Schema
  import Ecto.Changeset


  schema "monitors" do
    field :path, :string
    field :domain_id, :id

    timestamps()
  end

  @doc false
  def changeset(monitor, attrs) do
    monitor
    |> cast(attrs, [:path])
    |> validate_required([:path])
  end
end
