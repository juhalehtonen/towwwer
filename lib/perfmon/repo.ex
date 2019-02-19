defmodule PerfMon.Repo do
  use Ecto.Repo,
    otp_app: :perfmon,
    adapter: Ecto.Adapters.Postgres
end
