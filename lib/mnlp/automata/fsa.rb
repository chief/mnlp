# coding: utf-8
require 'active_support/all'
require 'pry'

module Mnlp
  module Automata
    class Fsa
  attr_reader :states, :transitions, :current_state, :recognize

  def initialize(options = {})
    options = defaults.merge(options)
    @states      = []
    options[:states].times { add_state }
    @transitions   = []
    @current_state = 0
    @recognize     = ""
  end

  def add_state(options = {})
    state   = Automata::State.new(size: states.size)
    @states.push state
  end

  def input_alphabet
    transitions.map(&:symbol).to_set
  end

  def has_state?(name)
    states.map(&:name).include? name
  end

  def find_state(name)
    states.select { |s| s.name == name }.first
  end

  def add_transition(from, to, symbol)
    raise Automata::NoStateError if !has_state?(from) || !has_state?(to)
    from_state = find_state(from)
    to_state   = find_state(to)
    transition = Automata::Transition.new(from_state, to_state, symbol)
    @transitions.push transition
  end

  def transition_table
    return @_transition_table if @_transition_table
    table = {}
    states.each_with_index do |state, index|
      state_transitions = transitions.select { |t| t.from == state }
      table[index] = Hash[state_transitions.map { |t| [t.symbol, states.index(t.to)] }]
    end

    @_transition_table = table
  end

  def final_state?(index)
    transition_table[index].empty?
  end

  def recognize!(symbol)
    if input_alphabet.include?(symbol) && transition_table[current_state].keys.include?(symbol)
      @current_state = transition_table[current_state][symbol]
      if final_state?(current_state)
        #puts "RECOGNIZE #@recognition"
        @recognize = true
        return
      end
    else
      @current_state = 0
    end

    @recognize = false
  end

  def first_symbol
    input_alphabet.first
  end

  private

  def defaults
    { states: 1 }
  end
end
end
end
