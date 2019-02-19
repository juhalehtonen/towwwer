defmodule PerfMon.WebsitesTest do
  use PerfMon.DataCase

  alias PerfMon.Websites

  describe "domains" do
    alias PerfMon.Websites.Domain

    @valid_attrs %{name: "some name", token: "some token"}
    @update_attrs %{name: "some updated name", token: "some updated token"}
    @invalid_attrs %{name: nil, token: nil}

    def domain_fixture(attrs \\ %{}) do
      {:ok, domain} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Websites.create_domain()

      domain
    end

    test "list_domains/0 returns all domains" do
      domain = domain_fixture()
      assert Websites.list_domains() == [domain]
    end

    test "get_domain!/1 returns the domain with given id" do
      domain = domain_fixture()
      assert Websites.get_domain!(domain.id) == domain
    end

    test "create_domain/1 with valid data creates a domain" do
      assert {:ok, %Domain{} = domain} = Websites.create_domain(@valid_attrs)
      assert domain.name == "some name"
      assert domain.token == "some token"
    end

    test "create_domain/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Websites.create_domain(@invalid_attrs)
    end

    test "update_domain/2 with valid data updates the domain" do
      domain = domain_fixture()
      assert {:ok, %Domain{} = domain} = Websites.update_domain(domain, @update_attrs)
      assert domain.name == "some updated name"
      assert domain.token == "some updated token"
    end

    test "update_domain/2 with invalid data returns error changeset" do
      domain = domain_fixture()
      assert {:error, %Ecto.Changeset{}} = Websites.update_domain(domain, @invalid_attrs)
      assert domain == Websites.get_domain!(domain.id)
    end

    test "delete_domain/1 deletes the domain" do
      domain = domain_fixture()
      assert {:ok, %Domain{}} = Websites.delete_domain(domain)
      assert_raise Ecto.NoResultsError, fn -> Websites.get_domain!(domain.id) end
    end

    test "change_domain/1 returns a domain changeset" do
      domain = domain_fixture()
      assert %Ecto.Changeset{} = Websites.change_domain(domain)
    end
  end

  describe "monitors" do
    alias PerfMon.Websites.Monitor

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
      assert Websites.list_monitors() == [monitor]
    end

    test "get_monitor!/1 returns the monitor with given id" do
      monitor = monitor_fixture()
      assert Websites.get_monitor!(monitor.id) == monitor
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
      assert monitor == Websites.get_monitor!(monitor.id)
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
    alias PerfMon.Websites.Report

    @valid_attrs %{data: %{}}
    @update_attrs %{data: %{}}
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
      assert Websites.list_reports() == [report]
    end

    test "get_report!/1 returns the report with given id" do
      report = report_fixture()
      assert Websites.get_report!(report.id) == report
    end

    test "create_report/1 with valid data creates a report" do
      assert {:ok, %Report{} = report} = Websites.create_report(@valid_attrs)
      assert report.data == %{}
    end

    test "create_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Websites.create_report(@invalid_attrs)
    end

    test "update_report/2 with valid data updates the report" do
      report = report_fixture()
      assert {:ok, %Report{} = report} = Websites.update_report(report, @update_attrs)
      assert report.data == %{}
    end

    test "update_report/2 with invalid data returns error changeset" do
      report = report_fixture()
      assert {:error, %Ecto.Changeset{}} = Websites.update_report(report, @invalid_attrs)
      assert report == Websites.get_report!(report.id)
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
