require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "DidYouMean" do

  context "methods search" do
    subject do
      Class.new{include(DidYouMean)}.new
    end

    it "should search methods by textual proximity" do
      def subject.foo; end
      subject.methods.search(:fo).first.should == "foo"
    end

    it "should put javascript_driver method in first place when searching by default_javascript_driver" do
      def subject.javascript_driver; end
      subject.methods.search(:default_javascript_driver).first.should == "javascript_driver"
    end

  end

  context "method missing" do
    subject do
      Class.new{include(DidYouMean)}.new
    end

    it "should suggest methods by textual proximity and call it if develepor types yes" do
      def subject.foo; end
      $stdout.should_receive(:print).with("Did you mean #{subject.class}.foo (yes/no)?\n")
      $stdin.should_receive(:gets).and_return('yes')
      subject.should_receive(:foo)
      subject.fo
    end
    
    it "should suggest methods by textual proximity and dont call it if develepor types no" do
      def subject.foo; end
      $stdout.should_receive(:print).with("Did you mean #{subject.class}.foo (yes/no)?\n")
      $stdin.should_receive(:gets).and_return('no')
      subject.should_not_receive(:foo)
      lambda {subject.fo}.should raise_error(NoMethodError)      
    end

  end

end
