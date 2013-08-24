# coding: utf-8

require "mnlp/automata/fsa"
require "mnlp/automata/state"
require "mnlp/automata/exceptions/no_state_error"
require "mnlp/automata/exceptions/duplicate_transition_error"
require "mnlp/automata/state"
require "mnlp/automata/transition"

module Mnlp
  module Automata
    extend self

    def recognize(string, machine, type = :char)
      if type == :char
        recognize_by_char(string, machine)
      end
    end

    private

    def recognize_by_char(string, machine)
      string.each_char do |char|
        machine.recognize!(char)
      end
    end
  end
end
