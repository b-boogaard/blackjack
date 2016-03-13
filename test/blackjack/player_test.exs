defmodule Blackjack.PlayerTest do
  use ExUnit.Case, async: false

  setup do
    {:ok, player} = Blackjack.Player.start_link("tester")
    {:ok, [player: player]}
  end

  test "player can respond with {:hit} when making a move", %{player: player} do
    Blackjack.Player.take_card(player, Blackjack.Card.new("10", "hearts"))
    Blackjack.Player.take_card(player, Blackjack.Card.new("6", "hearts"))

    assert {:hit} == player |> Blackjack.Player.make_move
  end

  test "player can respond with {:stand} when making a move", %{player: player} do
    Blackjack.Player.take_card(player, Blackjack.Card.new("10", "hearts"))
    Blackjack.Player.take_card(player, Blackjack.Card.new("9", "hearts"))

    assert {:stand} == player |> Blackjack.Player.make_move
  end
end
