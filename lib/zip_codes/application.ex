defmodule ZIPCodes.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {ZIPCodes, []}
    ]

    opts = [strategy: :one_for_one, name: ZIPCodes.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
