# frozen_string_literal: true

module JokersWay
  module Engine
    class Round
      # a round is finished when there is one player remaining with cards
      # a round is comprised of multiple plays
      # a play is concluded where each player has made a move (skip | play a card)

      attr_reader :state, :play
      attr_accessor :finished

      def initialize(players:, state:)
        @state = state

        trump_card_value = state.starting_player.team.score

        deck = Deck.build_with(players.count, trump_card_value:)
        deck.each_player(players) do |player, cards|
          player.cards = cards
        end

        @finished = []

        @play = Play.new(players)
      end

      def turn(player:, action:, **kwargs)
        case action
        when :play
          play_cards(player, cards: [*kwargs.delete(:cards)])
        when :skip
          skip(player)
        else
          raise "unknown action: #{action}"
        end

        @play.new_play! if @play.complete?

        # We'll also have to update who the new initiative is
        return unless player.cards.empty?

        @finished << player
      end

      def finished?
        @state.finished?
      end

      private

      def play_cards(player, cards:)
        @play.play_cards(player, cards:)
      end

      def skip(player, *, **)
        @play.skip(player)
      end
    end
  end
end
