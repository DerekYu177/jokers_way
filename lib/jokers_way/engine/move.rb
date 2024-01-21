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
        if previous && previous.size != current.size
          raise HandSizeMismatchError.new(previous, current) 
        end

        move = case current.size
        when 1, 2, 3
          OneToThreeCardMove.new(previous, current)
        when 4
          raise FourCardsError.new(previous, current)
        when 5
          FiveCardMove.new(previous, current)
        else
          raise IllegalNCardsError.new(previous, current)
        end

        move.validate!
      end

      private

      def split(cards)
        cards.partition(&:joker?)
      end
    end
  end
end
