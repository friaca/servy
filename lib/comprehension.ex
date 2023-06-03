defmodule Comprehension do
  @ranks [ "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A" ]

  @suits [ "♣", "♦", "♥", "♠" ]

  def generate_cards() do
    for rank <- @ranks, suit <- @suits, do: {rank, suit}
  end

  def get_random_cards(deck, n) do
    Enum.take_random(deck, n)
  end

  def get_four_hands(deck, cards_in_hand) do
    deck
    |> Enum.shuffle()
    |> Enum.chunk_every(cards_in_hand)
  end
end

# deck = Comprehension.generate_cards()
# IO.inspect(deck)
# IO.inspect(Comprehension.get_random_cards(deck, 13))
# IO.inspect(Comprehension.get_four_hands(deck, 13))
