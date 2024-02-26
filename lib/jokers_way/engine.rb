# frozen_string_literal: true

require_relative 'engine/game'
require_relative 'engine/player'
require_relative 'engine/round'
require_relative 'engine/deck'
require_relative 'engine/state'
require_relative 'engine/card'
require_relative 'engine/play'
require_relative 'engine/move'
require_relative 'engine/one_to_three_card_move'
require_relative 'engine/five_card_move'
require_relative 'engine/team'

module JokersWay
  module Engine
    class CannotSkipError < StandardError; end
    class CardNotFoundInHand < StandardError; end

    class AbstractMoveError < StandardError
      def initialize(previous, current)
        @previous = previous
        @current = current

        super()
      end
    end

    class HandSizeMismatchError < AbstractMoveError; end
    class UnequalRanksError < AbstractMoveError; end
    class GreaterMoveRequiredError < AbstractMoveError; end

    class IllegalNCardsError < AbstractMoveError
      def message
        <<~ERROR.squish
          played #{@current.size} number of cards
          whereas you require a hand of either 1, 2, 3, or 5
        ERROR
      end
    end

    class IncorrectPlayerOrderError < StandardError; end

    class GameFinished < StandardError; end

    ERRORS = [
      CannotSkipError,
      CardNotFoundInHand,
      HandSizeMismatchError,
      UnequalRanksError,
      IllegalNCardsError,
      IncorrectPlayerOrderError,
      GreaterMoveRequiredError,
    ].freeze
  end
end
