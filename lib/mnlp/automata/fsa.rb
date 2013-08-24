# coding: utf-8
require 'active_support/all'

module Mnlp
  module Automata
    class Fsa

      attr_reader :states, :current_state

      # @param options [Hash]
      # @option options [Fixnum] :number_of_states The initial number of states.
      #   Additions (beyond initial number) can be made through {#add_state}
      def initialize(options = {})
        options = defaults.merge(options)
        @states      = []
        options[:number_of_states].times { add_state }
        @current_state = states.first
      end

      # Adds a new {State}. At the moment there is no way to delete states from
      # the machine.
      def add_state
        @states << State.new(id: states.size)
      end

      # Gets machine alphabet from each state's alphabet
      # @return [Set] the alphabet recognized by the machine
      def alphabet
        states.map(&:alphabet).reduce(Set.new) { |a, v| a += v }
      end

      # Finds a state by its name or id
      # @param name_or_id [String, Fixnum] the name or id of the state
      # @return [Automata::State] or nil
      def find_state(name_or_id)
        states.select { |s| s.name == name_or_id || s.id == name_or_id }.first
      end

      # @see #find_state
      # @return [Boolean]
      def has_state?(name_or_id)
        find_state(name_or_id).present?
      end

      # Delegates transition creation to {Automata::State} class
      # @param from [String, Fixnum] the name or id of from state
      # @param to [String, Fixnum] the name or id of to state
      # @param symbol [String] the symbol of transition
      # @return [Array] from state's transitions
      def create_transition(from, to, symbol)
        raise Automata::NoStateError if !has_state?(from) || !has_state?(to)
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

      def recognize!(symbol)
        set_or_rollback_current_state(symbol)

        if current_state.final?
          return true
        end

        false
      end

      private

      def set_or_rollback_current_state(symbol)
        @current_state =
          if state_id = current_state.transit(symbol)
            find_state(state_id)
          else
            states.first
          end
      end

      def defaults
        { number_of_states: 1 }
      end
    end
  end
end
