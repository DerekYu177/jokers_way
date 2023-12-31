# frozen_string_literal: true

module JokersWay
  class Settings
    private_class_method :new

    class << self
      def instance
        @instance ||= new
      end

      def restore!
        return unless instance.attrs

        instance.attrs.each do |key|
          instance_variable_set("@#{key}", nil)
        end
      end

      def method_missing(*args, **kwargs, &block)
        instance.public_send(*args, **kwargs, &block)
      end
    end

    def initialize(**settings)
      settings = {
        winning_trump_card_value: 5,
        player_names: %w[RR R BA MA LQSS SDPAI],
      }.merge!(settings)

      settings.each do |key, value|
        instance_variable_set("@#{key}", value)
        self.class.attr_reader(key)
      end

      @attrs = settings.keys
    end

    attr_reader :attrs
  end
end
