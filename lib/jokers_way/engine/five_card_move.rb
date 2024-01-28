# frozen_string_literal: true

module JokersWay
  module Engine
    class FiveCardMove < Move
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

      def initialize(...)
        @pattern_value = nil
        @pattern_rank = nil
        super(...)
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
          current.map(&:current_rank).min
        when FOUR_OF_A_KIND, FULL_HOUSE
          major_group_rank(current)
        when FLUSH
          # there is no way to differentiate between flush ranks
          0
        end
      end

      def five_of_a_kind?
        convert_jokers(rank: current.map(&:current_rank).min) do
          group_of(5)
        end
      end

      def straight_flush?
        straight? && flush?
      end

      def four_of_a_kind?
        convert_jokers(rank: major_group_rank(current)) do
          group_of(4)
        end
      end

      def full_house?
        convert_jokers(rank: major_group_rank(current)) do
          group_of(3)
        end
      end

      def straight?
        # determine the missing digits
        # and then assign the missing values to jokers
        _, regular = split(current)
        convert_jokers(rank: missing_cards(regular.map(&:current_rank))) do
          consecutive?(current)
        end
      end

      def flush?
        convert_jokers(suit: current.first.suit) do
          same_suit?(current)
        end
      end

      def consecutive?(cards)
        cards.map(&:current_rank).sort.each_cons(2).all? { |a, b| b == a + 1 }
      end

      def group_of(size)
        big, small = current.group_by(&:current_rank).values
        return false unless big.size == size
        return false unless big.map(&:current_rank).uniq.size == 1
        return false if small && (small.map(&:current_rank).uniq.size != 1)

        true
      end

      def major_group_rank(cards)
        grouped(cards, jokers: false).first.first ||
          grouped(cards, jokers: true).first.first
      end

      def grouped(cards, jokers:)
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
        jokers, _regular = split(current)

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

        determine_missing_digits(input + missing, missing) if missing.size + input.size < 5

        missing
      end

      def same_suit?(cards)
        cards.map(&:current_suit).uniq.size == 1
      end
    end
  end
end
