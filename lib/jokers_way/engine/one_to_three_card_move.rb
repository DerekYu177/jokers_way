# frozen_string_literal: true

module JokersWay
  module Engine
    class OneToThreeCardMove < Move
      def validate!
        # all cards must be the same rank
        jokers, regular = split(current)

        if jokers.any?
          # jokers must adhere to the card with the lowest rank
          lowest_rank = current.map(&:current_rank).min

          jokers.each do |joker|
            joker.current_rank = lowest_rank
          end
        end

        raise UnequalRanksError.new(previous, current) unless equivalent_ranks?

        true
      end
    end
  end
end
