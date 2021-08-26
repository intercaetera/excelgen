defmodule Excelgen.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ExcelgenWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Excelgen.PubSub},
      # Start the Endpoint (http/https)
      ExcelgenWeb.Endpoint,
      # Start a worker by calling: Excelgen.Worker.start_link(arg)
      # {Excelgen.Worker, arg}

      # Start Excelgen genserver
      Excelgen.ExcelServer
    ]

    Excelgen.TaskRegistry.init()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Excelgen.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ExcelgenWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
