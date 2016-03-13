defmodule Blackjack.Supervisors.Game do
  use Supervisor

  def start_link(cache) do
    Supervisor.start_link(__MODULE__, cache)
  end

  def init(cache) do
    children = [
      worker(Blackjack.Game, cache, [id: make_ref])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
