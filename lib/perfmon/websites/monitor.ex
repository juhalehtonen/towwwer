defmodule PerfMon.Websites.Monitor do
  use Ecto.Schema
  import Ecto.Changeset
  alias PerfMon.Websites.Domain
  alias PerfMon.Websites.Report


  schema "monitors" do
    field :path, :string, default: "/"
    belongs_to :domain, Domain
    has_many :reports, Report

    timestamps()
  end

  @doc false
  def changeset(monitor, attrs) do
    monitor
    |> cast(attrs, [:path])
    |> validate_required([:path])
  end
end
