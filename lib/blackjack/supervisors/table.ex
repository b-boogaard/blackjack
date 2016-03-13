defmodule Blackjack.Supervisors.Table do
  @moduledoc false

  use Supervisor

  def start_link(state) do
    res = {:ok, sup} = Supervisor.start_link(__MODULE__, state)
    start_workers(sup, state)
    res
  end

  def start_workers(sup, state) do
    {:ok, cache} = Supervisor.start_child(sup, worker(Blackjack.Cache, [state]))
    Supervisor.start_child(sup, supervisor(Blackjack.Supervisors.Game, [[cache]]))
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end
