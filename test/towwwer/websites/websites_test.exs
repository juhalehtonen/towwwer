defmodule Towwwer.WebsitesTest do
  use Towwwer.DataCase

  alias Towwwer.Websites

  def unload_relations(obj, to_remove \\ nil) do
    assocs =
      if to_remove == nil,
        do: obj.__struct__.__schema__(:associations),
        else: Enum.filter(obj.__struct__.__schema__(:associations), &(&1 in to_remove))

    Enum.reduce(assocs, obj, fn assoc, obj ->
      assoc_meta = obj.__struct__.__schema__(:association, assoc)

      Map.put(obj, assoc, %Ecto.Association.NotLoaded{
        __field__: assoc,
        __owner__: assoc_meta.owner,
        __cardinality__: assoc_meta.cardinality
      })
    end)
  end

  describe "sites" do
    alias Towwwer.Websites.Site

    @valid_attrs %{
      base_url: "someurl",
      token: "sometoken",
      wp_content_dir: "dir",
      wp_plugins_dir: "dir",
      monitors: %{"0" => %{"path" => "/"}}
    }
    @update_attrs %{
      base_url: "someupdatedurl",
      token: "someupdatedtoken",
      wp_content_dir: "dirr",
      wp_plugins_dir: "dirr",
      monitors: %{"0" => %{"path" => "/"}}
    }
    @invalid_attrs %{
      base_url: nil,
      token: nil,
      wp_content_dir: nil,
      wp_plugins_dir: nil,
      monitors: nil
    }

    def site_fixture(attrs \\ %{}) do
      {:ok, site} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Websites.create_site()

      site
    end

    test "list_sites/0 returns all sites" do
      site = site_fixture()
      assert Websites.list_sites() == [unload_relations(site)]
    end

    test "get_site!/1 returns the site with given id" do
      site = site_fixture()
      assert unload_relations(Websites.get_site!(site.id)) == unload_relations(site)
    end

    test "create_site/1 with valid data creates a site" do
      assert {:ok, %Site{} = site} = Websites.create_site(@valid_attrs)
      assert site.base_url == "someurl"
      assert site.token == "sometoken"
    end

    test "create_site/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Websites.create_site(@invalid_attrs)
    end

    # test "update_site/2 with valid data updates the site" do
    #   site = site_fixture()
    #   assert {:ok, %Site{} = site} = Websites.update_site(site, @update_attrs)
    #   assert site.base_url == "someupdatedurl"
    #   assert site.token == "someupdatedtoken"
    # end

    test "update_site/2 with invalid data returns error changeset" do
      site = site_fixture()
      assert {:error, %Ecto.Changeset{}} = Websites.update_site(site, @invalid_attrs)
      assert unload_relations(site) == unload_relations(Websites.get_site!(site.id))
    end

    test "delete_site/1 deletes the site" do
      site = site_fixture()
      assert {:ok, %Site{}} = Websites.delete_site(site)
      assert_raise Ecto.NoResultsError, fn -> Websites.get_site!(site.id) end
    end

    test "change_site/1 returns a site changeset" do
      site = site_fixture()
      assert %Ecto.Changeset{} = Websites.change_site(site)
    end
  end

  describe "monitors" do
    alias Towwwer.Websites.Monitor

    @valid_attrs %{path: "some path"}
    @update_attrs %{path: "some updated path"}
    @invalid_attrs %{path: nil}

    def monitor_fixture(attrs \\ %{}) do
      {:ok, monitor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Websites.create_monitor()

      monitor
    end

    test "list_monitors/0 returns all monitors" do
      monitor = monitor_fixture()
      [listed_monitor] = Websites.list_monitors()
      assert [unload_relations(listed_monitor)] == [unload_relations(monitor)]
    end

    test "get_monitor!/1 returns the monitor with given id" do
      monitor = monitor_fixture()
      assert unload_relations(Websites.get_monitor!(monitor.id)) == unload_relations(monitor)
    end

    test "create_monitor/1 with valid data creates a monitor" do
      assert {:ok, %Monitor{} = monitor} = Websites.create_monitor(@valid_attrs)
      assert monitor.path == "some path"
    end

    test "create_monitor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Websites.create_monitor(@invalid_attrs)
    end

    test "update_monitor/2 with valid data updates the monitor" do
      monitor = monitor_fixture()
      assert {:ok, %Monitor{} = monitor} = Websites.update_monitor(monitor, @update_attrs)
      assert monitor.path == "some updated path"
    end

    test "update_monitor/2 with invalid data returns error changeset" do
      monitor = monitor_fixture()
      assert {:error, %Ecto.Changeset{}} = Websites.update_monitor(monitor, @invalid_attrs)
      assert unload_relations(monitor) == unload_relations(Websites.get_monitor!(monitor.id))
    end

    test "delete_monitor/1 deletes the monitor" do
      monitor = monitor_fixture()
      assert {:ok, %Monitor{}} = Websites.delete_monitor(monitor)
      assert_raise Ecto.NoResultsError, fn -> Websites.get_monitor!(monitor.id) end
    end

    test "change_monitor/1 returns a monitor changeset" do
      monitor = monitor_fixture()
      assert %Ecto.Changeset{} = Websites.change_monitor(monitor)
    end
  end

  describe "reports" do
    alias Towwwer.Websites.Report

    @valid_attrs %{
      data: %{},
      wpscan_data: %{},
      monitor: %{"path" => "/"}
    }
    @update_attrs %{
      data: %{},
      wpscan_data: %{},
      monitor: %{"path" => "/abc"}
    }
    @invalid_attrs %{data: nil}

    def report_fixture(attrs \\ %{}) do
      {:ok, report} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Websites.create_report()

      report
    end

    test "list_reports/0 returns all reports" do
      report = report_fixture()
      assert Websites.list_reports() == [unload_relations(report)]
    end

    test "get_report!/1 returns the report with given id" do
      report = report_fixture()
      assert unload_relations(Websites.get_report!(report.id)) == unload_relations(report)
    end

    test "create_report/1 with valid data creates a report" do
      assert {:ok, %Report{} = report} = Websites.create_report(@valid_attrs)
      assert report.data == %{}
    end

    test "create_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Websites.create_report(@invalid_attrs)
    end

    # test "update_report/2 with valid data updates the report" do
    #   report = report_fixture()
    #   assert {:ok, %Report{} = report} = Websites.update_report(report, @update_attrs)
    #   assert report.data == %{}
    # end

    test "update_report/2 with invalid data returns error changeset" do
      report = report_fixture()
      assert {:error, %Ecto.Changeset{}} = Websites.update_report(report, @invalid_attrs)
      assert unload_relations(report) == unload_relations(Websites.get_report!(report.id))
    end

    test "delete_report/1 deletes the report" do
      report = report_fixture()
      assert {:ok, %Report{}} = Websites.delete_report(report)
      assert_raise Ecto.NoResultsError, fn -> Websites.get_report!(report.id) end
    end

    test "change_report/1 returns a report changeset" do
      report = report_fixture()
      assert %Ecto.Changeset{} = Websites.change_report(report)
    end
  end
end
