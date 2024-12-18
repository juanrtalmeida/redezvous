defmodule Redezvous.Repo do
  use Ecto.Repo,
    otp_app: :redezvous,
    adapter: Ecto.Adapters.Postgres
end
