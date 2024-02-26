# frozen_string_literal: true

# Development ONLY
# $LOAD_PATH.unshift File.expand_path('lib', __dir__)
# require 'jokers_way'

# Production
require 'jokers_way'

game = JokersWay::CLI::Game.new
game.start!
