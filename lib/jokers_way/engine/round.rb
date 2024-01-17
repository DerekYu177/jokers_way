# frozen_string_literal: true

module JokersWay
  module Engine
    class Round
      # a round is finished when there is one player remaining with cards
      # a round is comprised of multiple plays
      # a play is concluded where each player has made a move (skip | play a card)

      attr_reader :state, :play
      attr_accessor :succeeded, :jailed

      def initialize(players:, state:)
        @state = state

        trump_card_value = state.offensive[:trump_card_value]

        deck = Deck.build_with(players.count, trump_card_value:)
        deck.each_player(players) do |player, cards|
          player.cards = cards
        end

        @succeeded = []
        @jailed = []

        @play = Play.new(players)
      end

      def turn(id:, action:, **kwargs)
        case action
        when :play
          play_cards(id, cards: [*kwargs.delete(:cards)])
        when :skip
          skip(id)
        else
          raise "unknown action: #{action}"
        end

        @play.new_play! if @play.complete?
      end

      def finished?
        false
      end

      def conclusion
        RoundConclusion
          .new(
            state,
            succeeded: @succeeded,
            jailed: @jailed,
          )
      end

      private

      def play_cards(id, cards:)
        # first, make sure that the cards that are played are valid
        @play.play_cards(id, cards: cards)

        # ensure that cards 
        # are popped from the hand
        # this may seem excessive 
        # because we already did it when we fetched the hand, 
        # but this would be where the hand is accepted
      end

      def skip(id, *, **)
        @play.skip(id)
      end
    end
  end
end
