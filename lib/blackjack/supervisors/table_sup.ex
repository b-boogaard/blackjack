defmodule Blackjack.Supervisors.TableSup do
  @moduledoc false

  use Supervisor

  ## Api

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  ## Callbacks

  def init([]) do
    children = [
      supervisor(Blackjack.Supervisors.Table, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
