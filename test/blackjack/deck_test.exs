defmodule Blackjack.DeckTest do
  use ExUnit.Case

  doctest Blackjack.Deck

  test "creates an array with 52 elements" do
    assert length(Blackjack.Deck.create_deck) == 52
  end

  test "creates all permutations required in a deck" do
    assert Enum.sort(card_list) == Enum.sort(Blackjack.Deck.create_deck)
  end

  test "returns the `deck` in random order" do
    deck = card_list
    shuffled_deck = Blackjack.Deck.shuffle(deck)

    assert length(deck) == length(shuffled_deck)
    assert deck != shuffled_deck
  end

  test "added duplicate values to `shuffle` has no effect on total size" do
    deck = card_list
    shuffled_deck = Blackjack.Deck.shuffle(deck, deck)

    assert length(shuffled_deck) == length(deck)
  end

  test "sending values to `cards_in` will add them back to the deck" do
    deck = card_list
    card = Enum.take(deck, 1)
    short_deck = Enum.drop(deck, 1)

    assert Enum.find(short_deck, &(&1 == card)) == nil

    shuffled_deck = Blackjack.Deck.shuffle(short_deck, card)

    assert Enum.sort(shuffled_deck) == Enum.sort(short_deck ++ card)
  end

  test "`draw` returns first element of deck and new deck state" do
    deck = card_list
    {:ok, card, new_deck} = Blackjack.Deck.draw(deck)

    assert card == Enum.take(deck, 1)
    assert new_deck == Enum.drop(deck, 1)
  end

  defp card_list do
    for suit <- ["D", "S", "C", "H"],
    value <- ["A", "2", "3", "4", "5", "6",
              "7", "8", "9", "10", "J", "Q", "K"],
    into: [], do: value <> suit
  end
end
