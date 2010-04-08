require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "DidYouMean" do
  
  before(:all) do
    Object.class_eval { include(DidYouMean) }
  end
  
  after(:all) do
    Object.class_eval { include(DidYouMean) }
  end
  
  subject { Object.new }
  it "should search methods by textual proximity" do
    def subject.foo; end
    subject.methods.search(:fo).first.should == "foo"
  end
  
  it "should put javascript_driver method in first place when searching by default_javascript_driver" do
    def subject.javascript_driver; end
    subject.methods.search(:default_javascript_driver).first.should == "javascript_driver"
  end
  
end
