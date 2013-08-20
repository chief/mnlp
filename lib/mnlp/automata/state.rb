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
        @transitions.push Automata::Transition.new(state, symbol)
      end

      def alphabet
        transitions.map(&:symbol).to_set
      end

      def final_state?
        transitions.empty?
      end

      private

      def default_name(size)
        "q#{size}"
      end
    end
  end
end
