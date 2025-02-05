defmodule HookRelayWeb.CatchAndRelease do
  @moduledoc """
  Controller for API calls to the server.
  """

  use HookRelayWeb, :controller
  use Plug.ErrorHandler
  require Logger
  alias HookRelay.Config, as: HConf
  alias HookRelay.Relay

  def error404(conn) do
    conn
    |> json(%{error: "Invalid Path! Endpoint contacted is not mapped to a relay configuration."})
    |> halt()
  end

  def error401(conn, :no_key) do
    conn
    |> json(%{
      error:
        "Request body did not contain the 'proof_key' parameter, which is required for this relay endpoint."
    })
    |> halt()
  end

  def error401(conn, :bad_key) do
    conn
    |> json(%{
      error:
        "Request body proof_key parameter did not match the one set in the relay endpoint configuration file."
    })
    |> halt()
  end

  def error_client_rq(conn, target) do
    conn
    |> json(%{
      error: "Failed to relay to the client endpoint #{target}!"
    })
    |> halt()
  end

  # relay caught msg
  defp relay_msg(conn, target, relay_msg) do
    # relay request
    # send request
    Relay.relay(target, relay_msg)
    |> case do
      :failed ->
        "Request to the target '#{target}' failed! Check issue on the target side."
        |> Logger.error()

        # send failure response
        error_client_rq(conn, target)

      :ok ->
        "Message relay to target '#{target}' was successful!"
        |> Logger.info()

        # :success
        render(conn, :release, msg: %{result: :message_relayed})
    end
  end

  def catcher(conn, params) do
    # get path data
    [path | _t] = Map.get(conn, :path_info)
    # Generate message from params
    relay_msg = build_msg(params)
    # check if relay is configured
    # returns config if found
    HConf.get_relay(path)
    |> case do
      # Endpoint reached is not mapped in the config
      :not_found ->
        "Unmapped relay attempted. Endpoint '/#{path}' is not mapped within the configuration file."
        |> Logger.error()

        error404(conn)

      # Endpoint does not require a proof_key
      %{"proof_key" => "", "target" => target} ->
        Logger.debug("Request to endpoint '/#{path}' succeeded does not require proof_key check.")
        relay_msg(conn, target, relay_msg)

      # Proof key required
      %{"proof_key" => proof_key, "target" => target} ->
        # Check for `proof_key` in the body
        relay_msg
        |> Map.get("proof_key")
        |> case do
          # proof_key matches the one in the config
          ^proof_key ->
            Logger.debug("Request to endpoint '/#{path}' succeeded proof_key check.")
            relay_msg(conn, target, relay_msg)

          # no proof_key parameter
          nil ->
            "Request to endpoint '/#{path}' did not contain the proof_key parameter in the request body."
            |> Logger.error()

            error401(conn, :no_key)

          # proof_key not matching
          _ ->
            "Request to endpoint '/#{path}' proof_key parameter did not match the one set in the relay config."
            |> Logger.error()

            error401(conn, :bad_key)
        end

        #
    end
  end

  @doc """
  Builds relay message from POST parameters
  """
  @spec build_msg(map()) :: map()
  def build_msg(http_params, bad_keys \\ ["_"]) do
    http_params
    |> Map.drop(bad_keys)
  end
end
