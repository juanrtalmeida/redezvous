defmodule Redezvous.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      RedezvousWeb.Telemetry,
      Redezvous.Repo,
      {DNSCluster, query: Application.get_env(:redezvous, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Redezvous.PubSub},
      # Start the Absinthe.Subscription process
      {Absinthe.Subscription, [RedezvousWeb.Endpoint]},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Redezvous.Finch},
      # Start a worker by calling: Redezvous.Worker.start_link(arg)
      # {Redezvous.Worker, arg},
      # Start to serve requests, typically the last entry
      RedezvousWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Redezvous.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RedezvousWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
