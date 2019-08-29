defmodule PagBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: PagBackend.Worker.start_link(arg)
      # {PagBackend.Worker, arg}
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: nil,
        options: [
          port: 9000,
          dispatch: PagBackend.Dispatcher.dispatch()
        ]
      ),
      {PagBackend.Repo, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PagBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
