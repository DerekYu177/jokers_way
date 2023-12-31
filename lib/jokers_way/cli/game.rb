# frozen_string_literal: true

require 'pry'
require 'pry-byebug'

module JokersWay
  module CLI
    class Game
      def initialize
        @game = Engine::Game.new
      end

      def start!
        loop do
          puts
          puts "Current player: #{current_player}"
          puts available_commands

          input = gets.chomp.strip

          action, info = parse_action(input)

          turn(current_player, action:, **info)
        end
      rescue Interrupt
        puts
        puts 'Exiting, thanks for playing!'
      end

      private

      def parse_action(input)
        if input == '?'
          [:hand, {}]
        elsif input == 'q'
          [:quit, {}]
        end
      end

      def turn(id, action:, **_kwargs)
        case action
        when :hand
          hand(id)
        when :quit
          raise Interrupt
        end
      end

      def hand(id)
        name = current_player_name(id)
        hand = @game.players.find { |player| player.name == name }.cards
        puts hand.map { |card| CLI::Card.new(card).inspect }
      end

      def available_commands
        "\t? for your hand\n" \
          "\t* for actions this play\n" \
          "\ts to skip your turn\n" \
          "\tq to quit\n" \
          "\tType the shorthand for your card to play it\n"
      end

      def current_player_name(id)
        play = @game.round.instance_variable_get(:@play)
        play.metadata[id]
      end

      def current_player
        @game.round.instance_variable_get(:@play).current_player
      end
    end
  end
end
