# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(JokersWay::CLI::Card) do
  describe '.pop!' do
    subject { described_class.pop!(shorthand, hand: hand) }

    context 'when shorthand cannot be found in hand' do
      let(:hand) { [JokersWay::Engine::Card.new(13, suit: 'Clubs')] }
      let(:shorthand) { "13" }

      it 'raises' do
        expect { subject }.to(raise_error(JokersWay::CLI::CardNotFoundInHand, shorthand))
      end
    end

    context 'jokers can be found without a suit' do
      let(:hand) { [JokersWay::Engine::Card.new(17)] }
      let(:shorthand) { "17" }

      it do
        card = subject

        expect(card).not_to(be_nil)
        expect(card.rank).to(eq(17))
        expect(card.joker?).to(be_truthy)
      end

      it 'removes from hand' do
        subject

        expect(hand).to(be_empty)
      end
    end
  end
end
