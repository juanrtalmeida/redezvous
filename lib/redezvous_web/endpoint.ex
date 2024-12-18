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

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug Absinthe.Plug, schema: RedezvousWeb.Schema

  if Mix.env() == :dev do
    plug Absinthe.Plug.GraphiQL, schema: RedezvousWeb.Schema
  end
end
