require 'rspec'
require 'resty_test'

RSpec.configure do |c|
  c.before :suite do
    puts "NOTE: Running the test suite may take a long time. Please be patient."
  end
end