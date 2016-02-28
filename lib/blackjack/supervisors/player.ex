defmodule Blackjack.Supervisors.Player do
  import Supervisor.Spec, warn: false

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    children = [
      worker(Blackjack.Player, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
