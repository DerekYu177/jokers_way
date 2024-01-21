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
      rescue StandardError => e
        handle!(e) ? retry : raise
      rescue Interrupt
        puts
        puts 'Exiting, thanks for playing!'
      end

      private

      def parse_action(input)
        case input
        when '?'
          [:hand, {}]
        when 'q'
          [:quit, {}]
        when 's'
          [:skip, {}]
        else
          [:play, { cards: parse_cards(input) }]
        end
      end

      def turn(id, action:, **)
        case action
        when :hand
          hand
        when :skip, :play
          @game.turn(id:, action:, **)
        when :quit
          raise Interrupt
        end
      end

      def hand
        hand = @game.find_player(current_player).cards

        human_readable_hand = hand
          .sort_by(&:current_rank)
          .map do |card|
            c = CLI::Card.new(card)
            "#{c.inspect}\t\t#{c.shorthand}"
          end

        puts human_readable_hand
      end

      def parse_cards(str)
        player = @game.find_player(current_player)

        shorthands = str.split
        cards = player.cards.dup

        shorthands.map do |shorthand|
          CLI::Card.pop!(shorthand, hand: cards)
        end
      end

      def available_commands
        "\t? for your hand\n" \
          "\ts to skip your turn\n" \
          "\tq to quit\n" \
          "\tType the shorthand for your card to play it\n"
      end

      def current_player
        @game.current_player
      end
    end
  end
end
