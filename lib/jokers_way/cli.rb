# frozen_string_literal: true

require_relative 'cli/game'
require_relative 'cli/card'
require_relative 'cli/error_handling'

module JokersWay
  module CLI
    class CardNotFoundInHand < StandardError
      attr_reader :shorthand

      def initialize(shorthand)
        @shorthand = shorthand
        super
      end
    end

    ERRORS = [CardNotFoundInHand].freeze
  end
end
