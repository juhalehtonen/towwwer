defmodule PerfMon.Websites.Report do
  use Ecto.Schema
  import Ecto.Changeset
  alias PerfMon.Websites.Monitor


  schema "reports" do
    field :data, :map
    belongs_to :monitor, Monitor

    timestamps()
  end

  @doc false
  def changeset(report, attrs) do
    report
    |> cast(attrs, [:data])
    |> validate_required([:data])
  end
end
