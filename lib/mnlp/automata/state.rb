# coding: utf-8

module Mnlp
  module Automata
    class State
      attr_reader :name

      def initialize(options = {})
        size  = options[:size] || 0
        @name = options[:name] || default_name(size)
      end

      private

      def default_name(size)
        "q#{size}"
      end
    end
  end
end
