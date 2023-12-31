# frozen_string_literal: true

module JokersWay
  module Engine
    class Card
      attr_reader :rank, :suit
      attr_accessor :current_rank, :current_suit

      SUITS = %w[Diamonds Clubs Hearts Spades].freeze

      JACK_RANK         = 11
      QUEEN_RANK        = 12
      KING_RANK         = 13
      ACE_RANK          = 14
      TRUMP_RANK        = 15
      LITTLE_JOKER_RANK = 16
      BIG_JOKER_RANK    = 17

      NUMBER_CARD_RANKS = [*2..10].freeze
      FACE_CARD_RANKS   = [JACK_RANK, QUEEN_RANK, KING_RANK, ACE_RANK].freeze
      SUIT_CARD_RANKS   = NUMBER_CARD_RANKS + FACE_CARD_RANKS
      JOKER_CARD_RANKS  = [LITTLE_JOKER_RANK, BIG_JOKER_RANK].freeze

      def initialize(rank, suit: nil)
        @rank = rank
        @suit = suit

        @current_rank = rank
        @current_suit = suit
      end
    end
  end
end
