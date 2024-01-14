# frozen_string_literal: true

require_relative 'engine/game'
require_relative 'engine/player'
require_relative 'engine/round'
require_relative 'engine/deck'
require_relative 'engine/state'
require_relative 'engine/card'
require_relative 'engine/round_conclusion'
require_relative 'engine/play'

module JokersWay
  module Engine
    # runs game

    class CannotSkipError < StandardError; end
    class CardNotFoundInHand < StandardError; end
  end
end
