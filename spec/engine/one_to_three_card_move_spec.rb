# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(JokersWay::Engine::OneToThreeCardMove) do
  describe '#validate!' do
    subject { described_class.new(cards).validate! }

    context('with one card') do
      let(:cards) { build_cards('10H') }
      it { is_expected.to(eq(true)) }
    end

    context('with two cards') do
      let(:cards) { build_cards('10H', '10H') }
      it { is_expected.to(eq(true)) }

      context('with one joker') do
        let(:cards) { build_cards('10H', '16') }
        it { is_expected.to(eq(true)) }

        it 'transforms the joker' do
          subject
          expect(cards.map(&:current_rank)).to(eq([10, 10]))
        end
      end
    end

    context('with three cards') do
      context 'when there is one joker' do
        let(:cards) { build_cards('16', '2H', '2C') }

        it 'transforms the joker' do
          subject
          expect(cards.map(&:current_rank)).to(eq([2, 2, 2]))
        end
      end

      context 'when there are two jokers' do
        let(:cards) { build_cards('16', '17', '7C') }

        it 'transforms the joker' do
          subject
          expect(cards.map(&:current_rank)).to(eq([7, 7, 7]))
        end
      end
    end
  end
end
