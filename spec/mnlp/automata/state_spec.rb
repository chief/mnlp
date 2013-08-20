require 'spec_helper'

describe Mnlp::Automata::State do
  context "when nothing is passed in #initialize" do
    subject { Mnlp::Automata::State.new }

    it "gives a default name" do
      subject.name.should == "q0"
    end
  end

  describe "#final_state?" do
    context "when state has no transitions" do
      it "is a final state" do
        subject.should be_final_state
      end
    end
  end
end
