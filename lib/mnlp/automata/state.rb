# coding: utf-8

module Mnlp
  module Automata
    class State
      attr_reader :name, :transitions

      def initialize(options = {})
        size  = options[:size] || 0
        @name = options[:name] || default_name(size)
        @transitions = []
      end

      def create_transition(state, symbol)
        transition = Automata::Transition.new(state, symbol)
        @transitions.push transition
      end

      def alphabet
        transitions.map(&:symbol).to_set
      end

      private

      def default_name(size)
        "q#{size}"
      end
    end
  end
end
