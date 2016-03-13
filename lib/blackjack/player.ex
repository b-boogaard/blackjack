defmodule Blackjack.Player do
  @moduledoc false

  use GenServer
  alias Blackjack.{Player, Hand, AI, Card}

  defstruct name: "", hand: %Hand{}, score: 0, meta: {}

  @type t :: %Player{}

  # Client

  def start_link(name, opts \\ []) do
    GenServer.start_link(__MODULE__, %Player{name: name}, opts)
  end

  def get_score(pid) do
    GenServer.call(pid, {:get_score})
  end

  def reset_player(pid) do
    GenServer.call(pid, {:reset})
  end

  def make_move(pid) do
    GenServer.call(pid, {:make_move})
  end

  def take_card(pid, card = %Card{}) do
    GenServer.cast(pid, {:draw, card})
  end

  # Server

  def handle_call({:get_score}, _from, player = %Player{}) do
    {:reply, Hand.hand_value(player.hand), player}
  end

  def handle_call({:reset}, _from, player = %Player{}) do
    updated_player = %Player{player | score: 0, hand: []}
    {:reply, updated_player, updated_player}
  end

  def handle_call({:make_move}, _from, player = %Player{}) do
    {:reply, AI.decision(player.hand), player}
  end

  def handle_cast({:draw, card}, player = %Player{}) do
    {:noreply, %Player{player | hand: Hand.add_card(player.hand, card)}}
  end
end
