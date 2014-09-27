# http://elixirquiz.github.io/2014-08-30-poker-part-1-a-deck-of-cards.html

defmodule Poker do

  defmodule Cards do

    @suits  [:spades, :hearts, :diamonds, :clubs]
    @names  [:ace, :king, :queen, :jack, 10, 9, 8, 7, 6, 5, 4, 3, 2]
    @values Enum.reverse(@names) |> Enum.zip(0..length(@names)-1) |> Enum.into(HashDict.new)

    def deck do
      for suit <- @suits, name <- @names, do: {suit, name}
    end

    def shuffled_deck do
      deck |> Enum.sort_by(fn (_) -> :random.uniform end)
    end

    def beats?({_, card}, {_, other_card}), do: HashDict.fetch(@values, card) > HashDict.fetch(@values, other_card)

  end

end

ExUnit.start

defmodule PokerTestHelpers do

  defmacro test_card_beats(a, b) do
    quote do
      test "#{unquote(a)} beats #{unquote(b)}" do
        c1 = {:spades, unquote(a)}
        c2 = {:diamonds, unquote(b)}
        assert   Poker.Cards.beats?(c1, c2)
        assert ! Poker.Cards.beats?(c2, c1)
      end
    end

  end

end

defmodule PokerTest do
  use ExUnit.Case, async: true
  import PokerTestHelpers

  test "a deck has 52 cards" do
    assert 52 == length(Poker.Cards.deck)
  end

  test "a shuffled deck has 52 cards" do
    assert 52 == length(Poker.Cards.shuffled_deck)
  end

  test "each shuffled deck is different" do
    d1 = Poker.Cards.shuffled_deck
    d2 = Poker.Cards.shuffled_deck
    d3 = Poker.Cards.shuffled_deck
    assert d1 != d2 && d2 != d3
  end

  test_card_beats(:ace, :king)
  test_card_beats(:king, :queen)
  test_card_beats(:queen, :jack)
  test_card_beats(:jack, 10)
  test_card_beats(10, 9)
  test_card_beats(9, 8)
  test_card_beats(8, 7)
  test_card_beats(7, 6)
  test_card_beats(6, 5)
  test_card_beats(5, 4)
  test_card_beats(4, 3)
  test_card_beats(3, 2)

end