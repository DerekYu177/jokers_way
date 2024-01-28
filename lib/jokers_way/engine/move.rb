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
        raise HandSizeMismatchError.new(previous, current) if previous && previous.size != current.size

        move = case current.size
               when 1, 2, 3
                 OneToThreeCardMove.new(current)
               when 5
                 FiveCardMove.new(current)
               else
                 raise IllegalNCardsError.new(previous, current)
               end

        move.validate!

        return true if previous.nil?

        previous_move = case previous.size
                        when 1, 2, 3
                          OneToThreeCardMove.new(previous)
                        when 5
                          FiveCardMove.new(previous)
                        end

        raise GreaterMoveRequiredError.new(previous, current) if (previous_move.value <=> move.value) >= 0

        true
      end
    end
  end
end
