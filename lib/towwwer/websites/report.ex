defmodule Towwwer.Websites.Report do
  use Ecto.Schema
  import Ecto.Changeset
  alias Towwwer.Websites.Monitor

  schema "reports" do
    field :data, :map
    field :mobile_data, :map
    field :wpscan_data, :map
    belongs_to :monitor, Monitor

    timestamps()
  end

  @doc false
  def changeset(report, attrs = %{monitor: _monitor}) do
    report
    |> cast(attrs, [:data, :mobile_data, :wpscan_data])
    |> put_assoc(:monitor, attrs.monitor)
  end

  def changeset(report, attrs) do
    report
    |> cast(attrs, [:data, :mobile_data, :wpscan_data])
    |> add_error(:no_monitor, "No monitor provided")
  end
end
