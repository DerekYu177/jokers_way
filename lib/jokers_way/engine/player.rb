# frozen_string_literal: true

require 'securerandom'

module JokersWay
  module Engine
    class Player
      attr_reader :name, :id
      attr_accessor :cards

      def initialize(name, id: nil)
        @id = id || SecureRandom.uuid
        @name = name
        @cards = []
      end
    end
  end
end
