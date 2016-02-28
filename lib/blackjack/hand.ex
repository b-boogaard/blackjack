defmodule Blackjack.Hand do
  alias Blackjack.{Card, Hand}

  defstruct cards: [%Card{}]

  @type t :: %Hand{}

  @spec new :: t
  def new, do: %Hand{}

  @spec add_card(t, Card.t) :: t
  def add_card(hand = %Hand{}, card = %Card{}) do
    %Hand{hand | cards: hand.cards ++ [card]}
  end

  @spec hand_value(t) :: {Integer.t, Integer.t}
  def hand_value(%Hand{cards: cards}) do
    cards
    |> Enum.map(&Card.face_value/1)
    |> Enum.reduce(fn (x, acc) ->
      {elem(x, 0) + elem(acc, 0), elem(x, 1) + elem(acc, 1)} end)
  end
end
