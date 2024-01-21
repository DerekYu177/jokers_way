# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(JokersWay::Engine::OneToThreeCardMove) do
  let(:current) { build_cards('10H') }
  let(:previous) { [] }

  describe '#validate!' do
    subject { described_class.validate!(previous, current) }

    context 'when not all cards are of equal ranks' do
      let(:current) { build_cards('2H', '2C', '3S') }

      it { expect { subject }.to(raise_error(JokersWay::Engine::UnequalRanksError)) }
    end

    context 'when there is one joker' do
      let(:current) do
        [
          build(:card, shorthand: '16'),
          build(:card, shorthand: '2H'),
          build(:card, shorthand: '2C'),
        ]
      end

      it "transforms the joker's current rank" do
        subject
        expect(current.map(&:current_rank)).to(eq([2, 2, 2]))
      end
    end
  end
end
