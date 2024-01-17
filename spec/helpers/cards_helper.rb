# frozen_string_literal: true

module Helpers
  module CardsHelper
    def build_cards(*shorthands)
      shorthands.map do |shorthand|
        build(:card, shorthand: shorthand)
      end
    end
  end
end
