defmodule Blackjack.Cache do
  @moduledoc """
  Stores `Blackjack.Game.t` data for a single game to enable
  game state to persist between process restarts.
  """

  use GenServer

  # Api

  @doc """
  Start new `Blackjack.Cache` process with an initial state.
  """
  @spec start_link(Blackjack.Game.t) :: {:ok, pid}
  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  @doc """
  Retrieve current state.
  """
  @spec get(pid) :: Blackjack.Game.t
  def get(pid) do
    GenServer.call(pid, {:get})
  end

  @doc """
  Replace the current state of the cache with the provided state.
  """
  @spec store(pid, Blackjack.Game.t) :: none
  def store(pid, state) do
    GenServer.cast(pid, {:store, state})
  end

  # Callbacks

  ## Calls

  def handle_call({:get}, _from, state) do
    {:reply, state, state}
  end

  ## Casts

  def handle_cast({:store, new_state}, _state) do
    {:noreply, new_state}
  end
end
