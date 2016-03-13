defmodule Blackjack.Cache do
  @moduledoc false

  use GenServer

  ## Api

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def get(pid) do
    GenServer.call(pid, {:get})
  end

  def store(pid, state) do
    GenServer.cast(pid, {:store, state})
  end

  def clear(pid) do
    GenServer.cast(pid, {:clear})
  end

  ## Callbacks

  def handle_call({:get}, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:store, new_state}, _state) do
    {:noreply, new_state}
  end

  def handle_cast({:clear}, _state) do
    new_state = %Blackjack.Game{}
    {:noreply, new_state}
  end
end
