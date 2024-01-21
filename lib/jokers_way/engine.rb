# frozen_string_literal: true

require_relative 'engine/game'
require_relative 'engine/player'
require_relative 'engine/round'
require_relative 'engine/deck'
require_relative 'engine/state'
require_relative 'engine/card'
require_relative 'engine/round_conclusion'
require_relative 'engine/play'
require_relative 'engine/move'
require_relative 'engine/one_to_three_card_move'
require_relative 'engine/five_card_move'

module JokersWay
  module Engine
    class CannotSkipError < StandardError; end
    class CardNotFoundInHand < StandardError; end

    class AbstractMoveError < StandardError
      def initialize(previous, current)
        @previous = previous
        @current = current

        super
      end
    end

    class HandSizeMismatchError < AbstractMoveError; end
    class UnequalRanksError < AbstractMoveError; end
    class FourCardsError < AbstractMoveError; end

    class IllegalNCardsError < AbstractMoveError
      def message
        "played #{@current.size} number of cards"
      end
    end

    class IncorrectPlayerOrderError < StandardError; end

    ERRORS = [
      CannotSkipError,
      CardNotFoundInHand,
      HandSizeMismatchError,
      UnequalRanksError,
      FourCardsError,
      IllegalNCardsError,
      IncorrectPlayerOrderError,
    ].freeze
  end
end
