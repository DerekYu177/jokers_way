# frozen_string_literal: true

require_relative 'cli/game'
require_relative 'cli/card'

module JokersWay
  module CLI
    class CardNotFoundInHand < StandardError
      attr_reader :shorthand

      def initialize(shorthand)
        @shorthand = shorthand
        super
      end
    end
  end
end
