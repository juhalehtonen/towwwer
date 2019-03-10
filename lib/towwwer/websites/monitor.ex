defmodule Towwwer.Websites.Monitor do
  use Ecto.Schema
  import Ecto.Changeset
  alias Towwwer.Websites.Site
  alias Towwwer.Websites.Report


  schema "monitors" do
    field :path, :string, default: "/"
    field :delete, :boolean, virtual: true # Not persisted to database
    belongs_to :site, Site
    has_many :reports, Report

    timestamps()
  end

  @doc false
  def changeset(monitor, attrs) do
    monitor
    |> cast(attrs, [:path, :delete])
    |> set_delete_action()
    |> validate_required([:path])
  end

  defp set_delete_action(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
