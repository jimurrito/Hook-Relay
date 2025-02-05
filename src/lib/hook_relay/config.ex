defmodule HookRelay.Config do
  @moduledoc """
  Config tools for the relay server.
  """

  require Logger

  @doc """
  Initializes state from config file
  """
  @spec initialize() :: {:ok}
  def initialize() do
    # Import config from file
    config = import_config()
    # verbose
    if Mix.env() == :dev do
      Logger.debug("Pulled state from config file.")
      IO.inspect(%{config_from_file: config})
    end

    # Create ets for state
    :hook_relay = :ets.new(:hook_relay, [:set, :protected, :named_table])
    # Set state to ets
    true = :ets.insert(:hook_relay, {"config", config})

    {:ok}
  end

  @doc """
  get config from ets
  """
  def get_config() do
    [{"config", config}] = :ets.lookup(:hook_relay, "config")
    config
  end

  @doc """
  reloads config from file - loads into ets
  """
  def reload_config() do
    config = import_config()
    true = :ets.insert(:hook_relay, {"config", config})
    {:ok}
  end

  @doc """
  Returns relay config if it exists.
  No need to check prior, a result atom will be provided if it is not found.
  """
  @spec get_relay(binary()) :: map() | :not_found
  def get_relay(relay) do
    get_config()
    |> Map.get(relay, :not_found)
  end

  # Imports a config from a file - converts from TOML to struct
  @spec import_config() :: map()
  defp import_config() do
    filename = Application.get_env(:hook_relay, :config_path) <> "./relay.config"
    Logger.debug("Importing from file: [#{filename}]")

    filename
    |> File.read!()
    |> Toml.decode(filename: filename)
    |> case do
      {:ok, config} -> config
      e -> e
    end
  end
end
