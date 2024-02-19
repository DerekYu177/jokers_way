# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(JokersWay::Engine::Round) do
  let(:players) { JokersWay::Settings.player_names.map { JokersWay::Engine::Player.new(_1) } }
  let(:state) do
    JokersWay::Engine::State.new(
      players:,
      starting_player: players.first,
    )
  end

  let(:trump_card_value) { 2 }

  before do
    JokersWay::Engine::Team.distribute!(players) do |teams|
      teams.each do |team|
        team.score = trump_card_value
      end
    end
  end

  describe '.new' do
    subject { described_class.new(players:, state:) }

    let(:trump_card_value) { 3 }

    it 'sets the trump card value to the team with the initiative' do
      subject

      cards = players.map(&:cards).flatten
      trump_card = cards.find { |card| card.current_rank == JokersWay::Engine::Card::TRUMP_RANK }
      expect(trump_card.rank).to(eq(3))
    end

    it 'distributes cards to each player' do
      subject

      players.each do |player|
        expect(player.cards).not_to(be_empty)
      end
    end
  end

  describe '#turn' do
    let(:round) { described_class.new(players:, state:) }

    describe 'skip' do
      it 'cannot skip when first turn' do
        expect { round.turn(player: players.first, action: :skip) }
          .to(raise_error(JokersWay::Engine::CannotSkipError))
      end
    end
  end
end
