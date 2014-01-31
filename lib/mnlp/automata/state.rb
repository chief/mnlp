# coding: utf-8

module Mnlp
  module Automata
    class State

      attr_reader :name, :transitions, :id
      attr_accessor :final

      # @param  options [Hash] initialization options
      # @option options [Fixnum] :id the id of state. Current implementation of
      #   id is actually the size of the Automaton states.
      # @option options [String] :name or the whole name of the state
      def initialize(options = {})
        options        = defaults.merge(options)
        @id            = options[:id] || 0
        @name          = set_name(options[:name])
        @transitions   = []
        @final         = options[:final]
        @should_visit  = {}
      end

      # Creates a new transition
      #
      # @param state  [Automata::State] the state to move to
      # @param symbol [String] the symbol to trigger the move
      def create_transition(state, symbol)
        transition = Transition.new(state, symbol)
        raise Automata::Exceptions::DuplicateTransitionError if transitions.include? transition
        check_determinism(symbol)

        @transitions << transition
      end

      # @return [Set] state's alphabet
      def alphabet
        transitions.map(&:symbol).to_set
      end

      # Whether state has transitions or not
      #
      # @return [Boolean]
      def final?
        transitions.empty? || final
      end

      def transition_table
        transitions.reduce({}) do |acc, val|
          acc[val.symbol] ||= []
          acc[val.symbol].push val.state.id
          acc
        end
      end

      def recognize_input?(symbol)
        alphabet.include? symbol
      end

      # Transits to another state
      #
      # @param symbol [String] the trigger symbol
      # @return [Fixnum] the id of state
      def transit(symbol)
        if transition_table[symbol]
          transition_table[symbol].first
        else
          nil
        end
      end

      private

      def defaults
        { id: 0, final: false }
      end

      def check_determinism(symbol)
        if alphabet.include?(symbol)
          raise Automata::Exceptions::InvalidTransitionError
        end
      end

      def set_name(name)
        name.present? ? name : default_name
      end

      def default_name
        "q#{id}"
      end
    end
  end
end
