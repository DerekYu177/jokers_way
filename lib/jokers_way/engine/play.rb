# frozen_string_literal: true

module JokersWay
  module Engine
    class Play
      # A play is completed where every player has completed an action
      # an action is { skip | play_card }

      attr_reader :table, :current_player, :metadata

      def initialize(players)
        @table = {}
        @metadata = {}

        players.each do |player|
          @table[player.id] = nil # ordered
          @metadata[player.id] = player.name
        end

        @current_player = table.keys.first
      end

      def play(player, cards:)
        @table[player] = :play # should be more than this
        complete_turn
      end

      def skip(player)
        raise CannotSkipError if first_play?

        @table[player] = :skip
        complete_turn
      end

      def complete?
        @table.values.none?(&:nil?)
      end

      private

      def new_play!
        @table.each_key { |id| @table[id] = nil }
      end

      def first_play?
        @table.values.all?(&:nil?)
      end

      def complete_turn
        current_player_index = @table.keys.find_index(current_player)
        current_player_index = (current_player_index + 1) % 5
        @current_player = @table.keys[current_player_index]
      end
    end
  end
end
