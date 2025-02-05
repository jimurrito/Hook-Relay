defmodule HookRelay.Relay do
  @moduledoc """
  Relays request to the the target server.
  """
require Logger

  @doc """
  Relays request to the the target server.
  """
  @spec relay(binary(), any()) :: :ok | :failed
  def relay(target, relay_msg) do
    Finch.build(:post, target, [], Jason.encode!(relay_msg))
    |> Finch.request(HookRelay.Finch)
    |> case do
      {:ok, resp} -> :ok
      {:error, msg} ->
        Logger.error("Failed to relay message!")
        IO.inspect(%{relay_request_failed: msg})
        :failed
    end
  end
end
