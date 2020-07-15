defmodule Acab.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Acab.Repo,
      # Start the Telemetry supervisor
      AcabWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Acab.PubSub},
      # Start the Endpoint (http/https)
      AcabWeb.Endpoint
      # Start a worker by calling: Acab.Worker.start_link(arg)
      # {Acab.Worker, arg}
    ]

    # Start the cookie storage
    Acab.Session.init()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Acab.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AcabWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
