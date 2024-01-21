# frozen_string_literal: true

FactoryBot.define do
  factory :card, class: JokersWay::Engine::Card do
    initialize_with do
      rank, suit = JokersWay::CLI::Card.send(:split, shorthand)
      new(rank, suit:)
    end
  end
end
