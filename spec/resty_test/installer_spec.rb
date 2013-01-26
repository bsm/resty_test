require 'spec_helper'

describe RestyTest::Installer do

  before do
    @level = RestyTest.logger.level
    RestyTest.logger.level = Logger::WARN
  end

  after do
    RestyTest.logger.level = @level
  end

  subject { described_class.instance }
  it { should be_a(Singleton) }

  its(:opts)  { should be_instance_of(String) }
  its(:paths) { should be_instance_of(RestyTest::Paths) }

end