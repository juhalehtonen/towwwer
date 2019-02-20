defmodule PerfMon.Websites do
  @moduledoc """
  The Websites context.
  """

  require Logger
  import Ecto.Query, warn: false
  alias PerfMon.Repo
  alias PerfMon.Websites.Site
  alias PerfMon.Tools.PageSpeed

  @doc """
  Returns the list of sites.

  ## Examples

      iex> list_sites()
      [%Site{}, ...]

  """
  def list_sites do
    Repo.all(from d in Site, preload: [monitors: [:reports]])
  end

  @doc """
  Return the list of Sites whose timestamp is older than configured time.

  Subtract N units of time from the current datetime, and see if it's bigger than
  last_check fields value. If it is, it means that last_check was more than
  N units of time ago and as such needs to be re-fetched.
  """
  def list_pending_sites do
    Repo.all from s in Site,
      where: s.updated_at < datetime_add(^NaiveDateTime.utc_now(), -1, "hour"),
      preload: [monitors: [:reports]]
  end


  @doc """
  Gets a single site.

  Raises `Ecto.NoResultsError` if the Site does not exist.

  ## Examples

      iex> get_site!(123)
      %Site{}

      iex> get_site!(456)
      ** (Ecto.NoResultsError)

  """
  def get_site!(id) do
    Site
    |> Repo.get!(id)
    |> Repo.preload([monitors: [:reports]])
  end

  @doc """
  Creates a site.

  ## Examples

      iex> create_site(%{field: value})
      {:ok, %Site{}}

      iex> create_site(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_site(attrs \\ %{}) do
    changeset = %Site{}
    |> Site.changeset(attrs)
    |> Repo.insert()

    case changeset do
      {:ok, site} ->
        PageSpeed.run_build_task_for_site_monitors(site)
      _ ->
        Logger.info("Failed to create site, so no reports are built.")
    end

   changeset
  end

  @doc """
  Updates a site.

  ## Examples

      iex> update_site(site, %{field: new_value})
      {:ok, %Site{}}

      iex> update_site(site, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_site(%Site{} = site, attrs) do
    site
    |> Site.changeset(attrs)
    |> Repo.update()
  end

  def bump_site_timestamp(%Site{} = site) do
    site
    |> Site.changeset(%{})
    |> Repo.update(force: true)
  end

  @doc """
  Deletes a Site.

  ## Examples

      iex> delete_site(site)
      {:ok, %Site{}}

      iex> delete_site(site)
      {:error, %Ecto.Changeset{}}

  """
  def delete_site(%Site{} = site) do
    Repo.delete(site)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking site changes.

  ## Examples

      iex> change_site(site)
      %Ecto.Changeset{source: %Site{}}

  """
  def change_site(%Site{} = site) do
    Site.changeset(site, %{})
  end

  alias PerfMon.Websites.Monitor

  @doc """
  Returns the list of monitors.

  ## Examples

      iex> list_monitors()
      [%Monitor{}, ...]

  """
  def list_monitors do
    Repo.all(from m in Monitor, preload: [:reports])
  end

  @doc """
  Gets a single monitor.

  Raises `Ecto.NoResultsError` if the Monitor does not exist.

  ## Examples

      iex> get_monitor!(123)
      %Monitor{}

      iex> get_monitor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_monitor!(id), do: Repo.get!(Monitor, id)

  @doc """
  Creates a monitor.

  ## Examples

      iex> create_monitor(%{field: value})
      {:ok, %Monitor{}}

      iex> create_monitor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_monitor(attrs \\ %{}) do
    %Monitor{}
    |> Monitor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a monitor.

  ## Examples

      iex> update_monitor(monitor, %{field: new_value})
      {:ok, %Monitor{}}

      iex> update_monitor(monitor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_monitor(%Monitor{} = monitor, attrs) do
    monitor
    |> Monitor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Monitor.

  ## Examples

      iex> delete_monitor(monitor)
      {:ok, %Monitor{}}

      iex> delete_monitor(monitor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_monitor(%Monitor{} = monitor) do
    Repo.delete(monitor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking monitor changes.

  ## Examples

      iex> change_monitor(monitor)
      %Ecto.Changeset{source: %Monitor{}}

  """
  def change_monitor(%Monitor{} = monitor) do
    Monitor.changeset(monitor, %{})
  end

  alias PerfMon.Websites.Report

  @doc """
  Returns the list of reports.

  ## Examples

      iex> list_reports()
      [%Report{}, ...]

  """
  def list_reports do
    Repo.all(Report)
  end

  def list_reports_of_monitor(monitor) do
    query = from r in Report,
      where: r.monitor_id == ^monitor.id,
      order_by: [desc: :inserted_at]

    Repo.all(query)
  end

  @doc """
  Gets a single report.

  Raises `Ecto.NoResultsError` if the Report does not exist.

  ## Examples

      iex> get_report!(123)
      %Report{}

      iex> get_report!(456)
      ** (Ecto.NoResultsError)

  """
  def get_report!(id) do
    Report
    |> Repo.get!(id)
  end

  @doc """
  Creates a report.

  ## Examples

      iex> create_report(%{field: value})
      {:ok, %Report{}}

      iex> create_report(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_report(attrs \\ %{}) do
    %Report{}
    |> Report.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a report.

  ## Examples

      iex> update_report(report, %{field: new_value})
      {:ok, %Report{}}

      iex> update_report(report, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_report(%Report{} = report, attrs) do
    report
    |> Report.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Report.

  ## Examples

      iex> delete_report(report)
      {:ok, %Report{}}

      iex> delete_report(report)
      {:error, %Ecto.Changeset{}}

  """
  def delete_report(%Report{} = report) do
    Repo.delete(report)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking report changes.

  ## Examples

      iex> change_report(report)
      %Ecto.Changeset{source: %Report{}}

  """
  def change_report(%Report{} = report) do
    Report.changeset(report, %{})
  end
end
