# coding: utf-8

module Mnlp
  module Automata
    class State

      attr_reader :name, :transitions

      # @param  options [Hash] initialization options
      # @option options [Fixnum] :suffix the suffix of state's name
      # @option options [String] :name or the whole name of the state
      def initialize(options = {})
        suffix  = options[:suffix] || 0
        @name   = set_name(options[:name], suffix)
        @transitions = []
      end

      # Creates a new transition
      # @param state  [Automata::State] the state to move to
      # @param symbol [String] the symbol to trigger the move
      def create_transition(state, symbol)
        transition = Transition.new(state, symbol)
        raise DuplicateTransitionError if transitions.include? transition

        @transitions << transition
      end

      # @return [Set] state's alphabet
      def alphabet
        transitions.map(&:symbol).to_set
      end

      def final?
        transitions.empty?
      end

      private

      def set_name(name, suffix)
        name.present? ? name : default_name(suffix)
      end

      def default_name(suffix)
        "q#{suffix}"
      end
    end
  end
end
