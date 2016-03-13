defmodule Blackjack.Player do
  @moduledoc """
  Process used to manage player state and interactions during
  a blackjack game.

  Defines the struct `%Blackjack.Player{name: String.t, hand: Blackjack.Hand.t}`.
  """

  use GenServer
  alias Blackjack.{Player, Hand, AI, Card}

  defstruct name: "", hand: %Hand{}

  @type t :: %Player{}

  # Api

  @doc """
  Starts a player process with the provided name and opts.
  """
  @spec start_link(String.t, []) :: {:ok, pid}
  def start_link(name, opts \\ []) do
    GenServer.start_link(__MODULE__, %Player{name: name}, opts)
  end

  @doc """
  Request that the player make their move.
  """
  @spec make_move(pid) :: {:hit} | {:stand}
  def make_move(pid) do
    GenServer.call(pid, {:make_move})
  end

  @doc """
  Receive a `Blackjack.Card.t` from the dealer, and add it to
  the players hand.
  """
  def take_card(pid, card = %Card{}) do
    GenServer.cast(pid, {:draw, card})
  end

  # Callbacks

  ## Calls

  def handle_call({:make_move}, _from, player = %Player{}) do
    {:reply, AI.decision(player.hand), player}
  end

  ## Casts

  def handle_cast({:draw, card}, player = %Player{}) do
    {:noreply, %Player{player | hand: Hand.add_card(player.hand, card)}}
  end
end
