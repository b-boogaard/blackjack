defmodule Blackjack.AI do
  alias Blackjack.Hand

  @spec decision(Hand.t) :: {:hit} | {:stand} | {:split}
  def decision(hand) do
    case total_hands(hand) do
      {21, _} -> {:stand}
      {_, 21} -> {:stand}
      {x, y} -> think(x, y)
    end
  end

  defp think(x, y) when x == y, do: think(x)
  defp think(x, y) when x > 21, do: think(y)
  defp think(x, y) when y > 21, do: think(x)
  defp think(x, y) when x > y, do: think(x)
  defp think(x, y) when x < y, do: think(y)
  defp think(x, y) when x < 17 and y < 17, do: {:hit}
  defp think(_x, _y), do: {:stand}

  defp think(x) when x > 17, do: {:stand}
  defp think(x) when x < 17, do: {:hit}
  defp think(_x), do: {:stand}

  defp total_hands(hand) do
    Hand.hand_value(hand)
  end
end
