require 'spec_helper'

describe Mnlp::Automata::State do
  let(:another_state) { Mnlp::Automata::State.new(id: 1) }

  describe ".initialize" do
    context "when nothing is passed" do
      it "has a default name" do
        expect(subject.name).to eq "q0"
      end

      it "has the default 0 id" do
        expect(subject.id).to eq 0
      end
    end

    context "when name passed" do
      subject { Mnlp::Automata::State.new name: "test" }

      it "has the name passed as param" do
        expect(subject.name).to eq "test"
      end

      it "has the default 0 id" do
        expect(subject.id).to eq 0
      end
    end

    context "when id passed" do
      subject { Mnlp::Automata::State.new id: 1 }

      it "has default name with suffix" do
        expect(subject.name).to eq "q" + "1"
      end
    end

    context "when suffix & name passed" do
      subject { Mnlp::Automata::State.new id: 2, name: "test" }

      it "has the only the name passed as param" do
        expect(subject.name).to eq "test"
      end
    end
  end

  describe "#final?" do
    context "when state has no transitions" do
      it "is an final state" do
        expect(subject).to be_final
      end
    end

    context "when state has transitions" do
      before do
        create_transitions
      end

      context "and final is false then" do
        it "is not a final state" do
          subject.final = false
          expect(subject).not_to be_final
        end
      end

      context "and final is true then" do
        it "is a final state" do
          subject.final = true
          expect(subject).to be_final
        end
      end
    end
  end

  describe "#create_transition" do
    before do
      subject.create_transition(another_state, "A")
    end

    it "creates a new transition" do
      expect(subject).to have(1).transitions
    end

    it "creates transition with self" do
      expect(subject).to have(1).transitions
    end

    context "when exactly the same transition occurs" do
      it "raises DuplicateTransitionError" do
        expect { subject.create_transition(another_state, "A") }.
          to raise_error(Mnlp::Automata::Exceptions::DuplicateTransitionError)
      end
    end
  end

  describe "#alphabet" do
    before do
      create_transitions
    end

    it "has an alphabet based on transitions' symbols" do
      expect(subject.alphabet).to be
      expect(subject.alphabet).to eq Set.new(["A", "B", "C"])
    end
  end

  describe "#transition_table" do
    before do
      create_transitions
    end

    it "has a valid transition_table" do
      expect(subject.transition_table).to eq(
          {"A"=>[1], "B"=>[1], "C"=>[1]}
        )
    end
  end

  describe "#recognize_input?" do
    before do
      create_transitions
    end

    context "when input inside alphabet" do
      it "recognizes input" do
        expect(subject).to be_recognize_input("A")
      end
    end

    context "when input different from alphabet" do
      it "does not recognizes input" do
        expect(subject).not_to be_recognize_input("X")
      end
    end
  end

  describe "#transit" do
    before do
      create_transitions
    end

    context "when transition is valid" do
      it "returns the transition state id" do
        expect(subject.transit("A")).to eq another_state.id
      end
    end

    context "when transition is invalid" do
      it "returns nil" do
        expect(subject.transit("X")).not_to be
      end
    end
  end

  # Helper methods
  def create_transitions
    subject.create_transition another_state, "A"
    subject.create_transition another_state, "B"
    subject.create_transition another_state, "C"
  end
end
