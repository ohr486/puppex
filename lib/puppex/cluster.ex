defmodule Puppex.Cluster do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(
      __MODULE__, args,
      name: Puppet.Cluster
            |> Module.concat("S#{Keyword.get(args, :cluster_sup_id)}")
            |> Module.concat("C#{Keyword.get(args, :cluster_id)}")
    )
  end

  def init(args) do
    supervise children(args), strategy: :one_for_all
  end

  def children(args) do
    1 .. Keyword.get(args, :worker_size)
    |> Enum.map(
      &worker(
        Puppex.Worker, [args ++ [worker_id: &1]],
        id: Puppet.Worker
            |> Module.concat("S#{Keyword.get(args, :cluster_sup_id)}")
            |> Module.concat("C#{Keyword.get(args, :cluster_id)}")
            |> Module.concat("W#{&1}")
      )
    )
  end
end
