defmodule Blackjack.CacheTest do
  use ExUnit.Case

  setup do
    {:ok, cache} = Blackjack.Cache.start_link(%Blackjack.Game{})
    {:ok, [cache: cache]}
  end

  test "retrieves current state", %{cache: cache} do
    assert %Blackjack.Game{} == Blackjack.Cache.get(cache)
  end

  test "stores new state", %{cache: cache} do
    new_state = %Blackjack.Game{
      players: [1, 2, 3],
      deck: [Blackjack.Card.new("10", "hearts")]
    }

    Blackjack.Cache.store(cache, new_state)

    assert new_state == Blackjack.Cache.get(cache)
  end
end
