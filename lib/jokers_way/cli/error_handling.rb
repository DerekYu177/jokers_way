# frozen_string_literal: true

module JokersWay
  module CLI
    class ErrorHandling
      class << self
        def handle!(error)
          case error
          when Engine::CannotSkipError
            emphasis!('You cannot skip on your first turn!')
          when CLI::CardNotFoundInHand
            emphasis!("Could not find the card that you played: #{shorthand}")
          else
            emphasis!("Unhandled Error: #{error}")
          end

          true
        end

        private

        def emphasis!(str)
          puts "#{'-' * 10}\t #{str} \t#{'-' * 10}"
        end
      end
    end
  end
end
