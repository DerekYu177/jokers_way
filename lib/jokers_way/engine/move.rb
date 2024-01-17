# frozen_string_literal: true

module JokersWay
  module Engine
    class Move
      attr_reader :previous, :current

      class << self
        def validate!(previous, current)
          new(previous, current).validate!
        end
      end

      def initialize(previous, current)
        @previous = previous
        @current = current
      end

      def validate!
        raise HandSizeMismatchError.new(previous, current) unless previous.size == current.size

        case current.size
        when 1, 2, 3
          OneToThreeCardsMove.new(current).validate!
        when 4
          raise FourCardsError
        when 5
          FiveCardsMove.new(current).validate!
        end


      end

      private

      def split(cards)
        cards.partition(&:joker?)
      end
    end
  end
end
