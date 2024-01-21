# frozen_string_literal: true

module JokersWay
  module Engine
    class Game
      attr_reader :players, :teams, :state, :round

      # each game is comprised of multiple rounds
      # the winning condition for a round is that one player has cards remaining at the end of a play
      # the winning condition for a game is that one team is at Settings.winning_trump_card_value
      # the first team (random) starts with the initiative
      # the first player on the team (random) begins with the first hand
      # if a team has the initiative
      # and takes the dragons_head
      # the number of team_trump_card_value that they go up is the number of those that are jailed
      # they keep the initiative
      # if a team does not have the initiative
      # and takes the dragons_head
      # the number of team_trump_card_value that they go up is 1 IFF they can jail the entire opposing team
      # they get the initiative

      def initialize
        @players = Settings.player_names.map do |name|
          Player.new(name)
        end

        @teams = @players.shuffle!
        @teams = [@teams[...(@teams.count / 2)], @teams[(@teams.count / 2)..]]
        offensive, defensive = @teams

        @players = offensive.zip(defensive).flatten # interleave teams

        @state = State.new(
          offensive: {
            player_ids: offensive.map(&:id),
            trump_card_value: 2,
            starting_player: offensive.first.id,
          },
          defensive: {
            player_ids: defensive.map(&:id),
            trump_card_value: 2,
            starting_player: nil,
          },
        )

        @round = Round.new(players: @players, state: @state)
      end

      def find_player(id)
        @players.find { |p| p.id == id }
      end

      def current_player
        @round.play.current_player
      end

      def turn(**kwargs)
        @round.turn(**kwargs)

        return unless @round.finished?

        # get the list of players who finished playing their hand, in order
        # then get the list of players who were jailed
        conclusion = @round.conclusion
        @state.new_round!(conclusion.updated_state)

        @round = Round.new(players: @players, state: @state)
      end
    end
  end
end
