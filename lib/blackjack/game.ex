defmodule Blackjack.Game do
  @moduledoc false

  defstruct players: [], deck: [%Blackjack.Card{}], cache: nil

  use GenServer
  alias Blackjack.{Player, Deck, Game, Cache}

  @type t :: %Game{players: [pid], deck: [Blackjack.Card.t], cache: pid}

  ## Api

  def start_link(cache) do
    GenServer.start_link(__MODULE__, cache)
  end

  def register_player(pid, player) do
    GenServer.cast(pid, {:register_player, player})
  end

  def play(pid) do
    GenServer.cast(pid, {:play})
  end

  def init(cache) do
    state = %Game{Cache.get(cache) | cache: cache}
    {:ok, state}
  end

  ## Callbacks

  def handle_cast({:play}, game) do
    play_game(game)
  end

  def handle_cast({:register_player, player}, game) do
    {:noreply, %Game{game | players: game.players ++ [player]}}
  end

  def terminate(_reason, state) do
    Cache.store(state.cache, state)
  end

  ## Private

  defp play_game(game) do
    n_game = deal_game(game)
    game_loop(game.players, n_game)
  end

  defp game_loop([], game), do: end_game(game)
  defp game_loop([player | rest], game) do
    n_game = player_move(player, game)
    game_loop(rest, n_game)
  end

  defp end_game(game) do
    print_winner = fn x -> IO.puts("Winner: #{inspect x}") end
    scores = Enum.map(game.players, fn p -> Player.get_score(p) end)

    IO.puts ""
    Enum.each(scores, fn x -> IO.puts('#{inspect x}') end)

    scores
    |> Enum.filter(fn x -> elem(x, 0) < 21 or elem(x, 1) < 21 end)
    |> Enum.max
    |> print_winner.()

    {:noreply, :done}
  end

  defp player_move(player, game) do
    case Player.make_move(player) do
      {:hit} ->
        n_game = deal_card(player, game)
        player_move(player, n_game)
      {:stand} ->
        game
    end
  end

  defp deal_game(game) do
    n_game = Enum.reduce(game.players, game, fn (p, g) -> deal_card(p, g) end)
    Enum.reduce(n_game.players, n_game, fn (p, g) -> deal_card(p, g) end)
  end

  defp deal_card(player, game) do
    {:ok, card, new_deck} = Deck.draw(game.deck)
    Player.take_card(player, card)
    %Game{game | deck: new_deck}
  end
end
