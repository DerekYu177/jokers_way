# frozen_string_literal: true

module JokersWay
  module Engine
    class State
      attr_reader :starting_player, :players

      def initialize(players:, starting_player:)
        @players = players
        @starting_player = starting_player
      end

      def update_with(round)
        dragon_head = round.finished.first

        jailed = @players - round.finished

        max_jailed = jailed.count == 3
        dragon_head_from_winning_team = dragon_head.team == starting_player.team

        starting_player.team.score += if dragon_head_from_winning_team && max_jailed
                                        2
                                      elsif dragon_head_from_winning_team || max_jailed
                                        1
                                      else
                                        0
                                      end

        @starting_player = dragon_head
      end

      def finished?
        starting_player.team.players.all? { |player| player.cards.empty? } ||
          starting_player.team.other.players.all? { |player| player.cards.empty? }
      end
    end
  end
end
