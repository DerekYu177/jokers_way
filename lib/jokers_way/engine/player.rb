# frozen_string_literal: true

require 'securerandom'

module JokersWay
  module Engine
    class Player
      attr_reader :name, :id
      attr_accessor :cards, :team

      def initialize(name, id: nil)
        @id = id || SecureRandom.uuid
        @name = name
        @team = nil
        @cards = []
      end

      def delete_cards!(cards_to_delete)
        @cards -= cards_to_delete
      end

      def inspect
        "<#{self.class.name} team=#{team.name} #cards=#{cards.count}>"
      end
    end
  end
end
