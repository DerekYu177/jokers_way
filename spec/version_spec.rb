# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('version') do
  it { expect(JokersWay::VERSION).to(eq('0.0.1')) }
end
