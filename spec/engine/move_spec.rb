# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(JokersWay::Engine::Move) do
  describe('.validate!') do
    let(:previous) { nil }
    subject { described_class.validate!(previous, current) }

    context 'HandSizeMismatchError' do
      let(:previous) { build_cards('2C') }
      let(:current) { build_cards('3C', '3H') }
      it { expect { subject }.to(raise_error(JokersWay::Engine::HandSizeMismatchError)) }
    end

    context 'IllegalNCardsError 4' do
      let(:current) { build_cards('3C', '3H', '3H', '3H') }
      it { expect { subject }.to(raise_error(JokersWay::Engine::IllegalNCardsError)) }
    end

    context 'IllegalNCardsError > 5' do
      let(:current) { build_cards('3C', '3H', '3H', '3H', '4H', '5H') }
      it { expect { subject }.to(raise_error(JokersWay::Engine::IllegalNCardsError)) }
    end

    context 'GreaterMoveRequiredError' do
      let(:previous) { build_cards('16', '16', '16', '17', '17') }
      let(:current) { build_cards('2H', '5H', '7H', '9H', '10H') }
      it { expect { subject }.to(raise_error(JokersWay::Engine::GreaterMoveRequiredError)) }
    end
  end
end
