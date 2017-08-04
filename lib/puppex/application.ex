defmodule Puppex.Application do
  @moduledoc false

  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    opts = [strategy: :one_for_all, name: Puppet.Supervisor]
    Supervisor.start_link(
      children([cluster_sup_size: 2, cluster_size: 2, worker_size: 2]),
    opts)
  end

  def children(args) do
    1 .. Keyword.get(args, :cluster_sup_size)
    |> Enum.map(
      &supervisor(
        Puppex.ClusterSup, [args ++ [cluster_sup_id: &1]],
        id: Module.concat(Puppex.ClusterSup, "S#{&1}")
      )
    )
  end
end
