# frozen_string_literal: true

module Helpers
  module PlayersHelper
    def build_players
      players = 6.times.map { build(:player) }

      JokersWay::Engine::Deck
        .build_with(players.count, trump_card_value: 2)
        .each_player(players) do |player, cards|
          player.cards = cards
        end

      players
    end
  end
end
