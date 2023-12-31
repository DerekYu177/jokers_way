# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(JokersWay::Engine::RoundConclusion) do
  let(:state_attrs) do
    {
      offensive: {
        player_ids: [1, 2, 3],
        trump_card_value: 2,
        starting_player: 1,
      },
      defensive: {
        player_ids: [4, 5, 6],
        trump_card_value: 2,
        starting_player: nil,
      },
    }
  end
  let(:state) { JokersWay::Engine::State.new(**state_attrs) }

  let(:succeeded) { [2, 1, 3, 4, 5] }
  let(:jailed) { [6] }

  let(:conclusion) { described_class.new(state, succeeded:, jailed:) }

  context '#updated_state' do
    it 'has the correct new state' do
      expect(conclusion.updated_state).to(eq(
        offensive: {
          starting_player: 2,
          trump_card_value: 3,
          player_ids: [1, 2, 3],
        },
        defensive: {
          starting_player: nil,
          trump_card_value: 2,
          player_ids: [4, 5, 6],
        },
      ))
    end
  end

  context '#new_offensive_trump_card_value' do
    subject { conclusion.new_offensive_trump_card_value }

    context 'when previous offensive team wins' do
      it { is_expected.to(eq(3)) }
    end

    context 'when previous defensive team wins' do
      let(:succeeded) { [4, 1, 2, 3, 5] }
      let(:jailed) { [6] }
      it { is_expected.to(eq(2)) }
    end

    context 'when previous defensive team wins with a landslide' do
      let(:succeeded) { [4, 5, 6] }
      let(:jailed) { [1, 2, 3] }
      it { is_expected.to(eq(3)) }
    end
  end

  context '#previous_offensive_trump_card_value' do
    subject { conclusion.previous_offensive_trump_card_value }

    context 'when previous offensive team wins' do
      let(:state_attrs) { super().deep_merge!(defensive: { trump_card_value: 3 }) }
      it { is_expected.to(eq(3)) }
    end

    context 'when previous defensive team wins' do
      let(:state_attrs) { super().deep_merge!(offensive: { trump_card_value: 4 }) }
      let(:succeeded) { [4, 5, 1, 2, 3] }
      it { is_expected.to(eq(4)) }
    end
  end

  it '#dragon_head_id' do
    expect(conclusion.dragon_head_id).to(eq(2))
  end
end
