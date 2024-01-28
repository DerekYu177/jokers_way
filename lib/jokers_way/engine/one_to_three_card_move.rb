# frozen_string_literal: true

module JokersWay
  module Engine
    class OneToThreeCardMove
      attr_reader :cards

      def initialize(cards)
        @cards = cards
      end

      def validate!
        # all cards must be the same rank
        jokers, _regular = split

        if jokers.any?
          # jokers must adhere to the card with the lowest rank
          lowest_rank = cards.map(&:current_rank).min

          jokers.each do |joker|
            joker.current_rank = lowest_rank
          end
        end

        true
      end

      def value
        cards.map(&:current_rank).min
      end

      private

      def equivalent_ranks?
        cards.map(&:current_rank).uniq.size == 1
      end

      def split
        cards.partition(&:joker?)
      end
    end
  end
end
