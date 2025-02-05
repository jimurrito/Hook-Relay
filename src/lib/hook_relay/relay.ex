defmodule HookRelay.Relay do
  @moduledoc """
  Relays request to the the target server.
  """
  require Logger

  @doc """
  Relays request to the the target server.
  """
  @spec relay(binary(), any(), false) :: :ok | :failed
  def relay(target, relay_msg, false) do
    Finch.build(:post, target, [], Jason.encode!(relay_msg))
    |> Finch.request(HookRelay.Finch)
    |> case do
      {:ok, _resp} ->
        :ok

      {:error, msg} ->
        Logger.error("Failed to relay message!")
        IO.inspect(%{relay_request_failed: msg})
        :failed
    end
  end

  @spec relay(binary(), any(), true) :: :async
  def relay(target, relay_msg, true) do
    {:ok, _ref} =
      Task.start(fn ->
        relay(target, relay_msg, false)
      end)

    :async
  end
end
