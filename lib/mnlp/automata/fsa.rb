# coding: utf-8
require 'active_support/all'

module Mnlp
  module Automata
    class Fsa

      attr_reader :states, :current_state, :recognize

      # @param options [Hash] initialization options
      # @option options [Fixnum] :number_of_states The initial number of states.
      #   Additions (beyond initial number) can be made through {#add_state}
      def initialize(options = {})
        options = defaults.merge(options)
        @states      = []
        options[:number_of_states].times { add_state }
        @current_state = states.first

        # @todo Remove this attribute
        @recognize     = ""
      end

      def add_state
        @states << State.new(id: states.size)
      end

      # Gets machine alphabet from each state's alphabet
      # @return [Set] the alphabet recognized by the machine
      def alphabet
        states.map(&:alphabet).reduce(Set.new) { |a, v| a += v }
      end

      # Finds a state by its name
      # @param name [String] the name of the state
      # @return [Automata::State] the state or nil
      def find_state(name)
        states.select { |state| state.name == name }.first
      end

      # @see #find_state
      # @return [Boolean]
      def has_state?(name)
        find_state(name).present?
      end

      # Delegates transition creation to {Automata::State} class
      # @param from [String] the name of from state
      # @param to [String] the name of to state
      # @param symbol [String] the symbol of transition
      # @return [Array] from state's transitions
      def create_transition(from, to, symbol)
        raise NoStateError if !has_state?(from) || !has_state?(to)
        from_state = find_state(from)
        to_state   = find_state(to)

        from_state.create_transition(to_state, symbol)
      end

      def state_transition_table
        states.reduce({}) do |result, state|
          result[state.id] = state.transition_table
          result
        end
      end

      # @todo Move some logic to State class
      def recognize!(symbol)
        if alphabet.include?(symbol) && state_transition_table[current_state.id].keys.include?(symbol)
          @current_state = state_transition_table[current_state.id][symbol]
          if current_state.final?
            #puts "RECOGNIZE #@recognition"
            @recognize = true
            return
          end
        else
          @current_state = states.first
        end

        @recognize = false
      end

      private

      def defaults
        { number_of_states: 1 }
      end
    end
  end
end
