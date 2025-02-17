defmodule HookRelay.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    #
    #
    #
    children = [
      # Start finch http client works
      {Finch, name: HookRelay.Finch},
      #
      # Watcher gen server for config file
      HookRelay.ConfigWatcher,
      #
      HookRelayWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:hook_relay, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: HookRelay.PubSub},
      # Start to serve requests, typically the last entry
      HookRelayWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HookRelay.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HookRelayWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
