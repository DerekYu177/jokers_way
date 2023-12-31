# frozen_string_literal: true

module JokersWay
  module CLI
    class Card
      attr_reader :card

      def initialize(card)
        @card = card
      end

      def inspect
        "<Card #{card.current_rank} of #{card.current_suit}>"
      end

      def shorthand
        [card.current_rank, card.current_suit].join('')
      end
    end
  end
end
