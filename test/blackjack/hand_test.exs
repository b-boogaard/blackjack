defmodule Blackjack.HandTest do
  use ExUnit.Case

  test "new returns an empty Blackjack.Hand.t" do
    assert %Blackjack.Hand{} == Blackjack.Hand.new
  end

  test "adds a card to a provided hand" do
    card = Blackjack.Card.new("10", "spades")
    card_2 = Blackjack.Card.new("ace", "hearts")

    expected = %Blackjack.Hand{cards: [card]}

    assert expected == Blackjack.Hand.add_card(Blackjack.Hand.new, card)

    expected_2 = %Blackjack.Hand{cards: expected.cards ++ [card_2]}

    assert expected_2 == Blackjack.Hand.add_card(expected, card_2)
  end

  test "sums up total value of hand" do
    card = Blackjack.Card.new("10", "spades")
    card_2 = Blackjack.Card.new("9", "hearts")

    hand = %Blackjack.Hand{cards: [card, card_2]}

    {19, 19} == Blackjack.Hand.hand_value hand
  end

  test "ace is added correctly" do
    card = Blackjack.Card.new("10", "spades")
    card_2 = Blackjack.Card.new("ace", "hearts")

    hand = %Blackjack.Hand{cards: [card, card_2]}

    {11, 21} = Blackjack.Hand.hand_value hand
  end
end
