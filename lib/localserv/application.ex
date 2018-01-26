defmodule Localserv.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Plug.Adapters.Cowboy, scheme: :http, plug: Localserv.Router, options: [port: 4040]},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Localserv.Supervisor]
    IO.puts "starting server at port 4040"
    Supervisor.start_link(children, opts)
  end
end
