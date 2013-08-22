require "spec_helper"

describe Mnlp::Automata::Fsa do
  describe "#initialize" do
    it "has the initial state q0" do
      expect(subject).to have(1).states
    end

    it "has a current_state of 0" do
      expect(subject.current_state).to eq 0
    end

    it "does not have input alphabet" do
      expect(subject.alphabet).to be_empty
    end

    context "when passing a number of states" do
      it "has states equals to the number passed" do
        machine = Mnlp::Automata::Fsa.new(number_of_states: 10)
        expect(machine).to have(10).states
      end
    end
  end

  describe "#add_state" do
    it "adds a new state" do
      subject.add_state
      expect(subject.states.size).to eq 1 + 1
    end

    it "has states with default names" do
      subject.add_state
      expect(subject.states.first.name).to eq "q0"
      expect(subject.states.last.name).to eq "q1"
    end
  end

  context "when adding multiple transitions" do
    before do
      4.times { subject.add_state }

      subject.create_transition "q0", "q1", "b"
      subject.create_transition "q1", "q2", "l"
      subject.create_transition "q2", "q3", "o"
      subject.create_transition "q3", "q4", "b"
    end

    it "has valid alphabet" do
      expect(subject.alphabet).to eq Set.new(["b", "l", "o"])
    end
  end

  context "when finding states" do
    before do
      subject.add_state
    end

    it "finds an existing state" do
      expect(subject.has_state?("q0")).to be_true
    end

    it "does not find a non-existing state" do
      expect(subject).not_to have_state("not-existing")
    end
  end

  context "when adding a transition" do
    before do
      2.times { subject.add_state }
    end

    context "and from state does not exist" do
      it "raises error" do
        expect { subject.create_transition("q10", "q1", "T") }.to raise_error(Mnlp::Automata::NoStateError)
      end
    end

    context "and to state does not exist" do
      it "raises error" do
        expect { subject.create_transition("q0", "q10", "T") }.to raise_error(Mnlp::Automata::NoStateError)
      end
    end
  end

  describe "#state_transition_table" do
    before do
      3.times { subject.add_state }

      subject.create_transition "q0", "q1", "b"
      subject.create_transition "q1", "q2", "a"
      subject.create_transition "q2", "q2", "a"
      subject.create_transition "q2", "q3", "!"
    end

    it "has a state transition table" do
      expect(subject.state_transition_table).
        to eq({ 0 => {"b"=>1},
                1 => {"a"=>2},
                2 => {"a"=>2, "!"=>3},
                3 => {} })

    end
  end

  describe "#find_state" do
    it "returns the first state by name" do
      pending("think better spec")
    end
  end

  describe "#recognize" do
    before do
      2.times { subject.add_state }

      subject.create_transition "q0", "q1", "c"
      subject.create_transition "q1", "q2", "h"
    end

    context "when a symbol is correct for the current_state" do
      it "proceeds to next state" do
        subject.recognize!("c")
        expect(subject.current_state).to eq 1
      end
    end

    context "when two symbols are correct" do
      it "finishes recognition for a 3 state automaton" do
        subject.recognize!("c")
        subject.recognize!("h")
        expect(subject.current_state).to eq 2
      end
    end

    context "when first symbol is accepted but not the second" do
      it "reverts to q0 state" do
        subject.recognize!("c")
        subject.recognize!("d")
        expect(subject.current_state).to eq 0
      end
    end
  end
end
