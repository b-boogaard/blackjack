defmodule Blackjack.Game do
  @moduledoc """
  Main process that coordinates the Blackjack game.

  Defines the struct `%Blackjack.Game{players: [], deck: [], cache: nil}`
  used to maintain the state of the game.
  """

  defstruct players: [], deck: [], cache: nil

  use GenServer
  alias Blackjack.{Player, Deck, Game, Cache}

  @type t :: %Game{players: [pid], deck: [Blackjack.Card.t], cache: pid}

  # Api

  @doc """
  Starts a new `Blackjack.Game` process that will retrieve its initial
  state from the procided `Blackjack.Cache` `pid`.
  """
  @spec start_link(pid) :: {:ok, pid}
  def start_link(cache) do
    res = {:ok, game} = GenServer.start_link(__MODULE__, cache)
    Blackjack.Game.play game
    res
  end

  @doc """
  Starts the game loop.
  """
  @spec play(pid) :: {:ok, :done}
  def play(pid) do
    GenServer.cast(pid, {:play})
  end

  # Callbacks

  @doc """
  Retrieves the state from the provided cache `pid` to use as
  the games initial state.

  The provided cache `pid` is added to the initial
  `Blackjack.Game.t`.
  """
  def init(cache) do
    state = %Game{Cache.get(cache) | cache: cache}
    {:ok, state}
  end

  @doc """
  Starts the game.
  """
  def handle_cast({:play}, game) do
    play_game(game)
  end

  @doc """
  Updates the `Blackjack.Cache` with the current state before
  the process is terminated.
  """
  def terminate(_reason, state) do
    Cache.store(state.cache, state)
  end

  # Private

  defp play_game(game) do
    n_game = deal_game(game)
    game_loop(game.players, n_game)
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

  defp game_loop([], game), do: end_game(game)
  defp game_loop([player | rest], game) do
    n_game = player_move(player, game)
    game_loop(rest, n_game)
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
end
