defmodule Blackjack.AITest do
  use ExUnit.Case

  test "hit when under 17" do
    for x <- 1..8, y <- 1..8 do
      assert Blackjack.AI.decision(make_hand(x, y)) == {:hit}
    end
  end

  test "stand when 17 or over" do
    for x <- 8..10, y <- 9..10 do
      assert Blackjack.AI.decision(make_hand(x, y)) == {:stand}
    end
  end

  test "stand when lhs is 21" do
    assert Blackjack.AI.decision(make_hand("ace", 10)) == {:stand}
  end

  test "stand when rhs is 21" do
    assert Blackjack.AI.decision(make_hand(10, "ace")) == {:stand}
  end

  defp make_hand(value_one, value_two) do
    hand = Blackjack.Hand.new
    hand = Blackjack.Hand.add_card(hand, get_card(value_one))
    Blackjack.Hand.add_card(hand, get_card(value_two))
  end

  defp get_card(value) when is_integer(value) do
    Blackjack.Card.new(Integer.to_string(value), "hearts")
  end

  defp get_card(value) when is_binary(value) do
    Blackjack.Card.new(value, "hearts")
  end
end
