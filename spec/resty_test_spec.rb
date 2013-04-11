require 'spec_helper'

describe RestyTest do

  subject { described_class }

  its(:config) { should be_instance_of(described_class::Config) }
  its(:logger) { should be_instance_of(Logger) }

  it "should be configurable" do
    subject.configure do |c|
      c.root.should == File.expand_path("../resty", __FILE__)
    end
  end

  it "should start, reload and stop nginx" do
    lambda { subject.start! }.should change {
      subject.running
    }.from(nil).to(true)

    res = Excon.get("http://127.0.0.1:1984/")
    res.status.should == 200
    res.body.should == "Success!\n"

    lambda { subject.reload! }.should_not change {
      subject.running
    }.from(true)

    lambda { subject.stop! }.should change {
      subject.running
    }.from(true).to(nil)
  end

end