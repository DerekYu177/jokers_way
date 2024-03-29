# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(JokersWay::Engine::FiveCardMove) do
  let(:cards) { [] }
  let(:move) { described_class.new(cards) }

  describe('#value') do
    subject { move.value }
    let(:pattern_value) { subject.first }
    let(:pattern_rank) { subject.last }

    context('five of a kind') do
      let(:cards) { build_cards('2C', '2H', '2H', '2H', '2S') }
      it { expect(pattern_value).to(eq(described_class::FIVE_OF_A_KIND)) }

      context('with one joker') do
        let(:cards) { build_cards('2C', '2H', '2H', '2H', '17') }
        it { expect(pattern_value).to(eq(described_class::FIVE_OF_A_KIND)) }
        it { expect(pattern_rank).to(eq(2)) }
      end

      context('with two jokers') do
        let(:cards) { build_cards('2C', '2H', '2H', '16', '17') }
        it { expect(pattern_value).to(eq(described_class::FIVE_OF_A_KIND)) }
        it { expect(pattern_rank).to(eq(2)) }
      end

      context('with three jokers') do
        let(:cards) { build_cards('2C', '2H', '16', '16', '17') }
        it { expect(pattern_value).to(eq(described_class::FIVE_OF_A_KIND)) }
        it { expect(pattern_rank).to(eq(2)) }
      end

      context('with four jokers') do
        let(:cards) { build_cards('2C', '17', '16', '16', '17') }
        it { expect(pattern_value).to(eq(described_class::FIVE_OF_A_KIND)) }
        it { expect(pattern_rank).to(eq(2)) }
      end

      context('with five jokers') do
        let(:cards) { build_cards('16', '17', '16', '16', '17') }
        it { expect(pattern_value).to(eq(described_class::FIVE_OF_A_KIND)) }
        it { expect(pattern_rank).to(eq(16)) }
      end
    end

    context('straight flush') do
      let(:cards) { build_cards('2C', '3C', '4C', '5C', '6C') }
      it { expect(pattern_value).to(eq(described_class::STRAIGHT_FLUSH)) }
      it { expect(pattern_rank).to(eq(2)) }

      context('with one joker') do
        let(:cards) { build_cards('2C', '16', '4C', '5C', '6C') }
        it { expect(pattern_value).to(eq(described_class::STRAIGHT_FLUSH)) }
        it { expect(pattern_rank).to(eq(2)) }
      end

      context('with two jokers') do
        let(:cards) { build_cards('3C', '16', '4C', '5C', '17') }
        it { expect(pattern_value).to(eq(described_class::STRAIGHT_FLUSH)) }
        it { expect(pattern_rank).to(eq(3)) }
      end
    end

    context('four of a kind') do
      let(:cards) { build_cards('12H', '12S', '12C', '12D', '2H') }
      it { expect(pattern_value).to(eq(described_class::FOUR_OF_A_KIND)) }

      context('with one joker') do
        let(:cards) { build_cards('12C', '12H', '12H', '2H', '17') }
        it { expect(pattern_value).to(eq(described_class::FOUR_OF_A_KIND)) }
        it { expect(pattern_rank).to(eq(12)) }
      end

      context('with two jokers') do
        let(:cards) { build_cards('12C', '12H', '16', '2H', '17') }
        it { expect(pattern_value).to(eq(described_class::FOUR_OF_A_KIND)) }
        it { expect(pattern_rank).to(eq(12)) }
      end

      context('with three jokers') do
        let(:cards) { build_cards('12C', '17', '16', '2H', '17') }
        it { expect(pattern_value).to(eq(described_class::FOUR_OF_A_KIND)) }
        it { expect(pattern_rank).to(eq(12)) }
      end
    end

    context('full house') do
      let(:cards) { build_cards('12H', '12S', '12C', '2D', '2H') }
      it { expect(pattern_value).to(eq(described_class::FULL_HOUSE)) }

      context('with one joker') do
        let(:cards) { build_cards('12H', '12S', '16', '2D', '2H') }
        it { expect(pattern_value).to(eq(described_class::FULL_HOUSE)) }
        it { expect(pattern_rank).to(eq(12)) }
      end
    end

    context('straight') do
      let(:cards) { build_cards('2H', '3H', '4S', '5H', '6C') }
      it { expect(pattern_value).to(eq(described_class::STRAIGHT)) }

      context('with one joker') do
        let(:cards) { build_cards('2H', '3H', '17', '5H', '6C') }
        it { expect(pattern_value).to(eq(described_class::STRAIGHT)) }
        it { expect(pattern_rank).to(eq(2)) }
      end

      context('with two jokers') do
        let(:cards) { build_cards('2C', '3H', '17', '5H', '16') }
        it { expect(pattern_value).to(eq(described_class::STRAIGHT)) }
        it { expect(pattern_rank).to(eq(2)) }
      end
    end

    context('flush') do
      let(:cards) { build_cards('2H', '3H', '5H', '6H', '7H') }
      it { expect(pattern_value).to(eq(described_class::FLUSH)) }

      context('with one joker') do
        let(:cards) { build_cards('2H', '3H', '17', '6H', '7H') }
        it { expect(pattern_value).to(eq(described_class::FLUSH)) }
        it { expect(pattern_rank).to(eq(17)) }
      end

      context('with two jokers') do
        let(:cards) { build_cards('2H', '16', '17', '6H', '7H') }
        it { expect(pattern_value).to(eq(described_class::FLUSH)) }
        it { expect(pattern_rank).to(eq(17)) }
      end
    end
  end
end
