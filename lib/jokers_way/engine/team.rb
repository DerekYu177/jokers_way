# frozen_string_literal: true

module JokersWay
  module Engine
    class Team
      attr_reader :players
      attr_accessor :score, :name, :other

      class << self
        def distribute!(players)
          teams = players.shuffle!
          teams = [teams[...(teams.count / 2)], teams[(teams.count / 2)..]]

          red, blue = teams

          team1 = new(red, name: :red)
          team2 = new(blue, name: :blue)

          team1.other = team2
          team2.other = team1

          yield [team1, team2]

          red.zip(blue).flatten # interleave teams
        end
      end

      def initialize(players, name:)
        @players = players
        @name = name
        @score = nil
        @other = nil

        assign!
      end

      def assign!
        players.each { |player| player.team = self }
      end

      def inspect
        "<Team '#{name}' players=#{players.map(&:id)}>"
      end
    end
  end
end
