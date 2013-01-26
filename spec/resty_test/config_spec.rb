require 'spec_helper'

describe RestyTest::Config do

  subject { described_class.instance }
  it { should be_a(Singleton) }

  its(:root)   { should be_instance_of(String) }
  its(:logger) { should be_instance_of(Logger) }
  its(:source) { should be_instance_of(String) }
  its(:config_file) { should == File.expand_path("../../nginx.conf", __FILE__) }
  its(:build_opts)  { should be_instance_of(Array) }

  [:root, :source, :logger, :build_opts, :config_file].each do |name|
    it { should respond_to(name) }
    it { should respond_to(:"#{name}=") }
  end

end