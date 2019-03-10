defmodule Towwwer.Repo do
  use Ecto.Repo,
    otp_app: :towwwer,
    adapter: Ecto.Adapters.Postgres
end
