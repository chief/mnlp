require 'spec_helper'

describe Mnlp::Automata::State do
  context "when nothing is passed in #initialize" do
    subject { Mnlp::Automata::State.new }

    it "gives a default name" do
      subject.name.should == "q0"
    end
  end

  describe "#accept_state?" do
    context "when state has no transitions" do
      it "is an accept state" do
        subject.should be_accept_state
      end
    end
  end

  describe "#create_transition" do
    let(:another_state) { Mnlp::Automata::State.new }

    it "creates a new transition" do
      subject.create_transition(another_state, "A")
      subject.should have(1).transitions
    end

    it "creates transition with self" do
      subject.create_transition(subject, "A")
      subject.should have(1).transitions
    end
  end

  describe "#alphabet" do
    let(:another_state) { Mnlp::Automata::State.new }

    before do
      subject.create_transition another_state, "A"
      subject.create_transition another_state, "B"
      subject.create_transition another_state, "C"
    end

    it "has an alphabet based on transitions' symbols" do
      subject.alphabet.should be
      subject.alphabet.should == Set.new(["A", "B", "C"])
    end
  end
end
