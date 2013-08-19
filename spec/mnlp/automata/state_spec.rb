require 'spec_helper'

describe Mnlp::Automata::State do
  context "when nothing is passed in #initialize" do
    subject { Mnlp::Automata::State.new }

    it "gives a default name" do
      subject.name.should == "q0"
    end
  end
end
