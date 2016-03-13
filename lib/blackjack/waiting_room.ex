defmodule Blackjack.WaitingRoom do
  @moduledoc false

  use GenServer
  alias Blackjack.{Deck, Game}

  def start_link do
    GenServer.start_link(__MODULE__, %Game{}, name: __MODULE__)
  end

  def register_player(pid, player) do
    GenServer.call(pid, {:register, player})
  end

  def handle_call({:register, player}, _from, state) do
    IO.puts "#{inspect state}"
    new_state = %Game{state | players: List.flatten([state.players | [player]])}

    case length(new_state.players) do
      4 -> start_game(new_state)
      _ -> {:reply, :added, new_state}
    end
  end

  # Private

  def start_game(game) do
    new_game = %Game{game | deck: Deck.create_deck |> Deck.shuffle}
    Supervisor.start_child(Blackjack.Supervisors.TableSup, [new_game])
    {:reply, :game_started, %Game{}}
  end
end
