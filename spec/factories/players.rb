# frozen_string_literal: true

FactoryBot.define do
  factory :player, class: JokersWay::Engine::Player do
    sequence :name, JokersWay::Settings.player_names.cycle

    initialize_with { new(attributes[:name]) }
  end
end
