defmodule Blackjack.Game do
  use GenServer
  alias Blackjack.{Player, Deck, Game}

  defstruct players: [], deck: [%Blackjack.Card{}]

  @type t :: %Game{players: [pid], deck: [Blackjack.Card.t]}

  def start_link() do
    GenServer.start_link(__MODULE__, %Game{}, name: __MODULE__)
  end

  def register_player(pid, player) do
    GenServer.cast(pid, {:register_player, player})
  end

  def play(pid) do
    GenServer.cast(pid, {:play})
  end

  def init(_game = %Game{}) do
    {:ok, %Game{
        players: [
          start_player(:one),
          start_player(:two),
          start_player(:three),
          start_player(:four)
        ],
      deck: Deck.create_deck |> Deck.shuffle
    }}
  end

  def handle_cast({:play}, game) do
    play_game(game)
  end

  def handle_case({:register_player, player}, game) do
    {:noreply, %Game{game | players: game.players ++ [player]}}
  end

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

  defp start_player(name) do
    {:ok, pid} = Supervisor.start_child(Blackjack.Supervisors.Player, [[name], []])
    pid
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
