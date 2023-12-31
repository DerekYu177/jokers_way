# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('global settings') do
  after { JokersWay::Settings.restore! }

  it 'uses the defaults' do
    expect(JokersWay::Settings.winning_trump_card_value).to(eq(5))
  end
end
