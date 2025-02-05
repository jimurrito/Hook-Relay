defmodule HookRelay.ConfigWatcher do
  @doc """
  Genserver to handle auto-updates to the system config from the config TOML file.
  """

  use GenServer
  alias HookRelay.Config, as: HConf

  @doc """
  Entry point for supervisor.
  """
  def start_link(_arg) do
    GenServer.start_link(__MODULE__, [])
  end

  # Called after start
  @impl true
  def init([]) do
    # Initialize ets with config
    {:ok} = HConf.initialize()
    # Start Filesystem listener
    {:ok, _pid} = :fs.start_link(FSConfigWatcher, Application.get_env(:hook_relay, :config_path))
    # Subscribe to listener
    {:fs.subscribe(FSConfigWatcher), []}
  end

  # cast handler for subscription updates
  @impl true
  def handle_info({_pid, {:fs, :file_event}, {_file, _action}}, _state) do
    {:ok} = HConf.reload_config()
    {:noreply, []}
  end
end
