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

  test "`draw` returns first element of deck and new deck state" do
    deck = card_list
    {:ok, card, new_deck} = Blackjack.Deck.draw(deck)

    assert card == Enum.take(deck, 1) |> List.first
    assert new_deck == Enum.drop(deck, 1)
  end

  defp card_list do
    for suit <- Blackjack.Card.suits,
    value <- Blackjack.Card.values,
    into: [], do: Blackjack.Card.new(value, suit)
  end
end
