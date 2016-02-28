defmodule Blackjack.Deck do
  import List, only: [first: 1]
  alias Blackjack.Card

  @type t :: [Card.t]

  @doc """
  Returns a list with all permutations matching a set
  of playing cards.

  The cards are represented as `%Blackjack.Card{}`.
  """
  @spec create_deck :: t
  def create_deck do
    for value <- Card.values, suit <- Card.suits,
    into: [], do: Card.new(value, suit)
  end

  @doc """
  Randomly picks a value from `deck` returning a tuple containing
  `:ok`, the value selected, and an updated array with `value` removed.
  """
  @spec draw(t) :: {:ok, Card.t, t}
  def draw(deck) do
    {:ok, first(deck), Enum.drop(deck, 1)}
  end

  @doc """
  Add `cards_in` list to the `deck` list, duplicates will be
  removed before `Enum.shuffle` is called.


  `:random.seed(:erlang.system_time)` is used as a seed before shuffling
  occurs.
  """
  @spec shuffle(t) :: t
  def shuffle(deck) do
    :random.seed(:erlang.system_time)

    deck
    |> Enum.uniq
    |> Enum.shuffle
  end
end
