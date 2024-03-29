# frozen_string_literal: true

module JokersWay
  module CLI
    class Card
      attr_reader :card

      class << self
        def pop!(shorthand, hand:)
          shorthand = shorthand.dup.upcase

          rank, suit = split(shorthand)

          Engine::Card.pop!(hand, rank:, suit:)
        rescue Engine::CardNotFoundInHand => _e
          raise CLI::CardNotFoundInHand, shorthand
        end

        private

        def split(shorthand)
          rank = shorthand.match(/\d+/).to_s
          suit_shorthand = shorthand.delete(rank)

          lookup = {
            'D' => 'Diamonds',
            'C' => 'Clubs',
            'H' => 'Hearts',
            'S' => 'Spades',
          }

          suit = lookup[suit_shorthand]

          [rank.to_i, suit]
        end
      end

      def initialize(card)
        @card = card
      end

      def humanize_rank
        case card.current_rank
        when *Engine::Card::NUMBER_CARD_RANKS
          card.current_rank
        when Engine::Card::JACK_RANK
          'Jack'
        when Engine::Card::QUEEN_RANK
          'Queen'
        when Engine::Card::KING_RANK
          'King'
        when Engine::Card::ACE_RANK
          'Ace'
        when Engine::Card::TRUMP_RANK
          "#{card.rank} (*)"
        when Engine::Card::LITTLE_JOKER_RANK
          'small Joker'
        when Engine::Card::BIG_JOKER_RANK
          'big Joker'
        end
      end

      def inspect
        if card.joker?
          "<Card #{humanize_rank}>"
        else
          "<Card #{humanize_rank} of #{card.current_suit}>"
        end
      end

      def shorthand
        if card.joker?
          card.current_rank
        else
          [card.current_rank, card.current_suit[0]].join
        end
      end
    end
  end
end
