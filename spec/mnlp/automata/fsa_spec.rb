require "spec_helper"

describe Mnlp::Automata::Fsa do
  context "when the machine is new" do
    it "has the initial state q0" do
      subject.should have(1).states
    end

    it "has a current_state of 0" do
      subject.current_state.should == 0
    end

    it "does not have input alphabet" do
      subject.alphabet.should be_empty
    end
  end

  describe "#initialize" do
    context "when passing a number of states" do
      it "has states equals to the number passed" do
        machine = Mnlp::Automata::Fsa.new(number_of_states: 10)
        machine.should have(10).states
      end
    end
  end

  context "when adding a state" do
    it "adds a new state" do
      subject.add_state
      subject.states.size.should == 1 + 1
    end

    it "has states with default names" do
      subject.add_state
      subject.states.first.name.should == "q0"
      subject.states.last.name.should  == "q1"
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
      subject.alphabet.should == Set.new(["b", "l", "o"])
    end
  end

  context "when finding states" do
    before do
      subject.add_state
    end

    it "finds an existing state" do
      subject.has_state?("q0").should == true
    end

    it "does not find a non-existing state" do
      subject.should_not have_state("q2")
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
      subject.state_transition_table.should ==
         { 0 => {"b"=>1},
           1 => {"a"=>2},
           2 => {"a"=>2, "!"=>3},
           3 => {} }

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
        subject.current_state.should == 1
      end
    end

    context "when two symbols are correct" do
      it "finishes recognition for a 3 state automaton" do
        subject.recognize!("c")
        subject.recognize!("h")
        subject.current_state.should == 2
      end
    end

    context "when first symbol is accepted but not the second" do
      it "reverts to q0 state" do
        subject.recognize!("c")
        subject.recognize!("d")
        subject.current_state.should == 0
      end
    end
  end
end
