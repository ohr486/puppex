defmodule Puppex.Worker do
  use GenServer

  def start_link(args) do
    GenServer.start_link(
      __MODULE__, args,
      name: Puppex.Worker
            |> Module.concat("S#{Keyword.get(args, :cluster_sup_id)}")
            |> Module.concat("C#{Keyword.get(args, :cluster_id)}")
            |> Module.concat("W#{Keyword.get(args, :worker_id)}")
    )
  end

  def init(args) do
    {:ok, [args]}
  end
end
