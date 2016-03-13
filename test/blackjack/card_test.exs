defmodule Blackjack.CardTest do
  use ExUnit.Case

  test "Blackjack.Card.new will return valid cards" do
    expected = %Blackjack.Card{value: "10", suit: "hearts"}

    assert expected == Blackjack.Card.new("10", "hearts")
  end

  test "Blackjack.Card.new fails with invalid values" do
    catch_error(Blackjack.Card.new("20", "whatever"))
  end

  test "returns tuples of numeric values" do
    for v <- ["2", "3", "4", "5", "6", "7", "8", "9", "10"] do
      {int_val, _} = Integer.parse(v)
      {int_val, int_val} = Blackjack.Card.new(v, "hearts") |> Blackjack.Card.face_value
    end
  end

  test "jack, queen, and king are treated as 10" do
    for v <- ["jack", "queen", "king"] do
      {10, 10} = Blackjack.Card.new(v, "hearts") |> Blackjack.Card.face_value
    end
  end

  test "ace returns values of 1 and 11" do
    {1, 11} = Blackjack.Card.new("ace", "hearts") |> Blackjack.Card.face_value
  end
end
