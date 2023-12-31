# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(JokersWay::Engine::Deck) do
  describe '.new' do
    subject { described_class.new(cards, trump_card_value:) }

    let(:cards) do
      [
        JokersWay::Engine::Card.new(2, suit: 'Diamonds'),
        JokersWay::Engine::Card.new(5, suit: 'Spades'),
      ]
    end
    let(:trump_card_value) { 5 }

    it 'shuffles all cards' do
      expect(cards).to(receive(:shuffle)).and_call_original
      subject
    end

    it 'updates any card that matches the trump card value' do
      same, changed = cards
      subject
      expect(same.current_rank).to(eq(2))
      expect(changed.current_rank).to(eq(JokersWay::Engine::Card::TRUMP_RANK))
    end
  end
end
