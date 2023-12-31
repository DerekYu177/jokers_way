# frozen_string_literal: true

module JokersWay
  module Engine
    class Deck
      CARDS_PER_DECK = 52
      CARDS_PER_HAND = CARDS_PER_DECK / 2

      class << self
        def build_with(count, trump_card_value:)
          cards = (count / 2).times.map { build }.flatten
          Deck.new(cards, trump_card_value:)
        end

        def build
          cards = []

          Card::SUITS.each do |suit|
            Card::SUIT_CARD_RANKS.each do |rank|
              cards << Card.new(rank, suit:)
            end
          end

          Card::JOKER_CARD_RANKS.each do |rank|
            cards << Card.new(rank)
          end

          cards
        end
      end

      attr_accessor :cards

      def initialize(cards, trump_card_value:)
        @cards = cards.shuffle

        @cards.each do |card|
          card.current_rank = Card::TRUMP_RANK if card.rank == trump_card_value
        end
      end

      def each_player(players, &block)
        cards_per_user = @cards.each_slice(CARDS_PER_HAND).to_a
        players.zip(cards_per_user, &block)
      end
    end
  end
end
