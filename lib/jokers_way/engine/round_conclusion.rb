# frozen_string_literal: true

module JokersWay
  module Engine
    class RoundConclusion
      attr_reader :previous_state, :succeeded, :jailed

      def initialize(state, succeeded:, jailed:)
        @previous_state = state
        @succeeded = succeeded
        @jailed = jailed
      end

      def updated_state
        {
          offensive: {
            starting_player: dragon_head_id,
            trump_card_value: new_offensive_trump_card_value,
            player_ids: new_offensive_player_ids,
          },
          defensive: {
            starting_player: nil,
            trump_card_value: previous_offensive_trump_card_value,
            player_ids: new_defensive_player_ids,
          },
        }
      end

      def dragon_head_id
        succeeded.first
      end

      def new_offensive_trump_card_value
        if previous_offensive_eq_current_offensive?
          previous_state.offensive[:trump_card_value] + jailed.count
        elsif jailed.count == 3
          previous_state.offensive[:trump_card_value] + 1
        else
          previous_state.defensive[:trump_card_value]
        end
      end

      def previous_offensive_trump_card_value
        if previous_offensive_eq_current_offensive?
          previous_state.defensive[:trump_card_value]
        else
          previous_state.offensive[:trump_card_value]
        end
      end

      def new_defensive_player_ids
        if previous_offensive_eq_current_offensive?
          previous_state.defensive[:player_ids]
        else
          previous_state.offensive[:player_ids]
        end
      end

      def new_offensive_player_ids
        if previous_offensive_eq_current_offensive?
          previous_state.offensive[:player_ids]
        else
          previous_state.defensive[:player_ids]
        end
      end

      private

      def previous_offensive_eq_current_offensive?
        previous_state.offensive[:player_ids].include?(dragon_head_id)
      end
    end
  end
end
