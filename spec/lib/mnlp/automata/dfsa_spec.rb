# coding: utf-8

require "spec_helper"

describe Mnlp::Automata::Dfsa do
  describe "#initialize" do
    it "has one state (the initial state)" do
      expect(subject).to have(1).states
    end

    it "has a current_state with id 0" do
      expect(subject.current_state.id).to eq 0
    end

    it "does not have any alphabet" do
      expect(subject.alphabet).to be_empty
    end

    context "when passing a number of states" do
      it "has states equals to the number passed" do
        machine = Mnlp::Automata::Dfsa.new(number_of_states: 10)
        expect(machine).to have(10).states
      end
    end
  end

  describe "#add_state" do
    before do
      subject.add_state
    end

    it "adds a new state" do
      expect(subject.states.size).to eq 1 + 1
    end

    it "has states with default names" do
      expect(subject.states.first.name).to eq "q0"
      expect(subject.states.last.name).to  eq "q1"
    end
  end

  describe "#alphabet" do
    before do
      create_transitions
    end

    it "has valid alphabet" do
      expect(subject.alphabet).to eq Set.new(["b", "a", "!"])
    end
  end

  describe "#has_state?" do
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

  describe "#create_transition" do
    before do
      2.times { subject.add_state }
    end

    context "when from state does not exist" do
      it "raises error" do
        expect { subject.create_transition("q10", "q1", "T") }.to(
          raise_error(Mnlp::Automata::Exceptions::NoStateError))
      end
    end

    context "when destination state does not exist" do
      it "raises error" do
        expect { subject.create_transition("q0", "q10", "T") }.to(
          raise_error(Mnlp::Automata::Exceptions::NoStateError))
      end
    end

    it "creates a new transition" do
      expect { subject.create_transition(0, 1, "a") }.to change{
        subject.transitions.size}.by(1)

    end

    context "when there is the same symbol to another state" do
      before do
        subject.add_state
        subject.create_transition 0, 1, "A"
      end

      it "raises an exception" do
        expect { subject.create_transition(0, 2, "A") }.to raise_error(
          Mnlp::Automata::Exceptions::InvalidTransitionError)
      end
    end
  end

  describe "#state_transition_table" do
    before do
      create_transitions
    end

    it "has a state transition table" do
      expect(subject.state_transition_table).to(
        eq({ 0 => {"b"=>1},
             1 => {"a"=>2},
             2 => {"a"=>2, "!"=>3},
             3 => {} }))
    end
  end

  describe "#find_state" do
    let(:state) { subject.states.first }

    it "returns the first state by name" do
      expect(subject.find_state("q0")).to eq state
    end

    it "returns the first state by id" do
      expect(subject.find_state(0)).to eq state
    end

    context "when state does not exist" do
      it "returns nil" do
        expect(subject.find_state(999)).not_to be
      end
    end
  end

  describe "#recognize" do
    before do
      2.times { subject.add_state }

      subject.create_transition 0, 1, "c"
      subject.create_transition 1, 2, "h"
      subject.recognize!("c")
    end

    context "when a symbol is correct for the current_state" do
      it "proceeds to next state" do
        expect(subject.current_state.id).to eq 1
      end
    end

    context "when two symbols are correct" do
      before do
        subject.recognize!("h")
      end

      it "finishes recognition for a 3 state automaton" do
        expect(subject.current_state.id).to eq 2
      end
    end

    context "when first symbol is accepted but not the second" do
      before do
        subject.recognize!("d")
      end

      it "reverts to q0 state" do
        expect(subject.current_state.id).to eq 0
      end
    end
  end

  # Helper methods
  def create_transitions
    3.times { subject.add_state }

    subject.create_transition 0, 1, "b"
    subject.create_transition 1, 2, "a"
    subject.create_transition 2, 2, "a"
    subject.create_transition 2, 3, "!"
  end
end
