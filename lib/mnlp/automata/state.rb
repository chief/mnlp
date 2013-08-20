# coding: utf-8

module Mnlp
  module Automata
    class State

      attr_reader :name, :transitions

      # @params options [Hash] initialization options
      # @option options [Fixnum] :suffix the suffix of state's name
      # @option options [String] :name or the whole name of the state
      def initialize(options = {})
        suffix  = options[:suffix] || 0
        @name   = options[:name] || default_name(suffix)
        @transitions = []
      end

      def create_transition(state, symbol)
        @transitions.push Transition.new(state, symbol)
      end

      def alphabet
        transitions.map(&:symbol).to_set
      end

      # @todo Think about this method name
      def final_state?
        transitions.empty?
      end

      private

      def default_name(suffix)
        "q#{suffix}"
      end
    end
  end
end
