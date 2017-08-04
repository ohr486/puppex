defmodule Puppex.ClusterSup do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(
      __MODULE__, args,
      name: Module.concat(Puppet.ClusterSup, "S#{Keyword.get(args, :cluster_sup_id)}")
    )
  end

  def init(args) do
    supervise(children(args), strategy: :one_for_all)
  end

  def children(args) do
    1 .. Keyword.get(args, :cluster_size)
    |> Enum.map(
      &supervisor(
        Puppex.Cluster, [args ++ [cluster_id: &1]],
        id: Puppex.Cluster
            |> Module.concat("S#{Keyword.get(args, :cluster_sup_id)}")
            |> Module.concat("C#{&1}")
      )
    )
  end
end
