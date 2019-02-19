defmodule PerfMon.Websites.Report do
  use Ecto.Schema
  import Ecto.Changeset


  schema "reports" do
    field :data, :map
    field :monitor_id, :id

    timestamps()
  end

  @doc false
  def changeset(report, attrs) do
    report
    |> cast(attrs, [:data])
    |> validate_required([:data])
  end
end
