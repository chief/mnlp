require "spec_helper"

describe Mnlp::Automata do
  describe ".recognize" do
    context "when type is set to :char" do
      let(:string) { "this is a very very small string chf" }

      let(:machine) do
        machine = Mnlp::Automata::Fsa.new(states: 4)

        machine.add_transition "q0", "q1", "c"
        machine.add_transition "q1", "q2", "h"
        machine.add_transition "q2", "q3", "f"

        machine
      end

      it "applies a machine to a string" do
        subject.recognize(string, machine).should be_true
      end
    end
  end
end
