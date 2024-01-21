# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(JokersWay::Engine::Play) do
  let(:play) { described_class.new(players) }
  let(:players) { build_players }

  describe '#play' do
    subject do
      current_player = players.find do |player|
        player.id == play.current_player
      end

      play.play_cards(
        current_player,
        cards: [current_player.cards.first],
      )
    end

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
