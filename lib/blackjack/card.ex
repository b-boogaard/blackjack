defmodule Blackjack.Card do
  alias Blackjack.Card

  @type t :: %Card{}

  defstruct value: "", suit: ""

  @spec new(String.t, String.t) :: t
  def new(value, suit) do
    cond do
      MapSet.member?(values, value) and MapSet.member?(suits, suit) ->
        %Card{value: value, suit: suit}
    end
  end

  @spec face_value(Card.t) :: {Integer.t, Integer.t}
  def face_value(%Card{value: value}) do
    cond do
      MapSet.member?(values, value) -> value_tuple(value)
    end
  end

  @spec values :: MapSet.t
  def values do
    MapSet.new(["ace", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "jack", "queen", "king"])
  end

  @spec suits :: MapSet.t
  def suits do
    MapSet.new(["spades", "hearts", "clubs", "diamonds"])
  end

  defp value_tuple(value) do
    case Integer.parse(value) do
      {val, _str} -> {val, val}
      :error -> letter_value(value)
    end
  end

  defp letter_value(value) when value == "ace", do: {1, 10}
  defp letter_value(_value), do: {10, 10}
end
