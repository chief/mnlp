require 'spec_helper'

describe Mnlp::Automata::State do

  describe "#initialize" do
    context "when nothing is passed" do
      subject { Mnlp::Automata::State.new }

      it "gives a default name" do
        subject.name.should == "q0"
      end
    end

    context "when name passed" do
      subject { Mnlp::Automata::State.new name: "test" }

      it "has the name passed as param" do
        subject.name.should == "test"
      end
    end

    context "when suffix passed" do
      subject { Mnlp::Automata::State.new suffix: 1 }

      it "has default name with suffix" do
        subject.name.should == "q" + "1"
      end
    end

    context "when suffix & name passed" do
      subject { Mnlp::Automata::State.new suffix: 1, name: "test" }

      it "has the only the name passed as param" do
        subject.name.should == "test"
      end
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

    before do
      subject.create_transition(another_state, "A")
    end

    it "creates a new transition" do
      subject.should have(1).transitions
    end

    it "creates transition with self" do
      subject.should have(1).transitions
    end

    context "when exactly the same transition occurs" do
      it "raises DuplicateTransitionError" do
        expect { subject.create_transition(another_state, "A") }.
          to raise_error(Mnlp::Automata::DuplicateTransitionError)
      end
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
