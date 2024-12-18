defmodule RedezvousWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :redezvous

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :redezvous
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug RedezvousWeb.Router
  plug Plug.Head
end
