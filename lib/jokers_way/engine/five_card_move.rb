# frozen_string_literal: true

module JokersWay
  module Engine
    class FiveCardMove
      # pattern values
      # a higher pattern value is absolutely
      # greater than one of lower value
      # regardless of the differences in pattern rank
      FLUSH = 1
      STRAIGHT = 2
      FULL_HOUSE = 3
      FOUR_OF_A_KIND = 4
      STRAIGHT_FLUSH = 5
      FIVE_OF_A_KIND = 6

      attr_reader :cards

      def initialize(cards)
        @pattern_value = nil
        @pattern_rank = nil
        @cards = cards
      end

      def validate!
        value
      end

      def value
        [pattern_value, pattern_rank]
      end

      private

      def pattern_value
        return FIVE_OF_A_KIND if five_of_a_kind?
        return STRAIGHT_FLUSH if straight_flush?
        return FOUR_OF_A_KIND if four_of_a_kind?
        return FULL_HOUSE if full_house?
        return STRAIGHT if straight?
        return FLUSH if flush?

        nil
      end

      def pattern_rank
        case pattern_value
        when FIVE_OF_A_KIND, STRAIGHT_FLUSH, STRAIGHT
          cards.map(&:current_rank).min
        when FOUR_OF_A_KIND, FULL_HOUSE
          major_group_rank
        when FLUSH
          cards.map(&:current_rank).max
        end
      end

      def five_of_a_kind?
        convert_jokers(rank: cards.map(&:current_rank).min) do
          group_of(5)
        end
      end

      def straight_flush?
        straight? && flush?
      end

      def four_of_a_kind?
        convert_jokers(rank: major_group_rank) do
          group_of(4)
        end
      end

      def full_house?
        convert_jokers(rank: major_group_rank) do
          group_of(3)
        end
      end

      def straight?
        # determine the missing digits
        # and then assign the missing values to jokers
        _, regular = split
        convert_jokers(rank: missing_cards(regular.map(&:current_rank))) do
          consecutive?
        end
      end

      def flush?
        convert_jokers(suit: cards.first.suit) do
          same_suit?
        end
      end

      def consecutive?
        cards.map(&:current_rank).sort.each_cons(2).all? { |a, b| b == a + 1 }
      end

      def group_of(size)
        big, small = cards.group_by(&:current_rank).values
        return false unless big.size == size
        return false unless big.map(&:current_rank).uniq.size == 1
        return false if small && (small.map(&:current_rank).uniq.size != 1)

        true
      end

      def major_group_rank
        grouped(jokers: false).first.first ||
          grouped(jokers: true).first.first
      end

      def grouped(jokers:)
        cards
          .map(&:current_rank)  # [12, 12, 12, 12, 2]
          .tap do |ranks|
          unless jokers
            ranks.reject! do |rank|
              JokersWay::Engine::Card::JOKER_CARD_RANKS.include?(rank)
            end
          end
        end
          .group_by(&:itself)   # { 12 => [12, 12, 12, 12], 2 => [2] }
          .values               # [[12, 12, 12, 12], [2]]
          .sort                 # [[2], [12, 12, 12, 12]]
          .reverse              # [[12, 12, 12, 12], [2]]
      end

      def convert_jokers(rank: nil, suit: nil)
        jokers, _regular = split

        ranks = if rank.is_a?(Array)
                  rank
                else
                  [rank] * jokers.size
                end

        jokers.zip(ranks).each do |joker, r|
          joker.current_rank = r if r
          joker.current_suit = suit if suit
        end

        result = yield

        unless result
          jokers.each do |joker|
            joker.current_rank = joker.rank
            joker.current_suit = joker.suit
          end
        end

        result
      end

      def missing_cards(input, missing = [])
        # FUN MINI CHALLENGE:
        # given an integer array of < 5
        # provide an output such that output is a consecutive list of five integers from a specified list
        # specified list = [*2..14]

        input.sort!
        return missing if input.size == 5

        is_consecutive = ->(arr) { arr.sort.each_cons(2).all? { |a, b| b == a + 1 } }

        if is_consecutive.call(input)
          lowest_value = input.first
          highest_value = input.last

          missing << if highest_value == JokersWay::Engine::Card::SUIT_CARD_RANKS.last
                       lowest_value - 1
                     else
                       highest_value + 1
                     end
        else
          normalized_input = input.map { |i| i - input.first }
          gap = ([*0..4] - normalized_input).map { |i| i + input.first }
          missing.push(*gap)
        end

        missing_cards(input + missing, missing) if missing.size + input.size < 5

        missing
      end

      def same_suit?
        cards.map(&:current_suit).uniq.size == 1
      end

      def split
        cards.partition(&:joker?)
      end
    end
  end
end
