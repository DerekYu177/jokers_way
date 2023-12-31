# frozen_string_literal: true

module JokersWay
  module Engine
    class State
      attr_accessor :offensive, :defensive

      def initialize(offensive:, defensive:)
        @offensive = offensive
        @defensive = defensive
      end

      def new_round!(state)
        @offensive.merge!(state[:offensive])
        @defensive.merge!(state[:defensive])

        nil
      end
    end
  end
end
