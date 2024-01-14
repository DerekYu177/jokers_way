# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(JokersWay::Engine::Play) do
  let(:play) { described_class.new(players) }
  let(:players) do
    JokersWay::Settings.player_names.map { |name| JokersWay::Engine::Player.new(name) }
  end

  describe '#play' do
    subject { play.play(play.current_player, cards: []) } 

    it 'changes the player' do
      expect { subject }.to(change { play.current_player })
    end
  end

  describe '#skip' do
    it 'unskippable when first player' do
      expect { play.skip(play.current_player) }.to(raise_error(JokersWay::Engine::CannotSkipError))
    end
  end
end
