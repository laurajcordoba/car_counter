defmodule CarCounter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      CarCounter.Repo,
      # Start the Telemetry supervisor
      CarCounterWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: CarCounter.PubSub},
      # Start the Endpoint (http/https)
      CarCounterWeb.Endpoint
      # Start a worker by calling: CarCounter.Worker.start_link(arg)
      # {CarCounter.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CarCounter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CarCounterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
