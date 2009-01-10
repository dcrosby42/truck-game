unless $SPECS_ARE_HELPED  # ifndef yall
$SPECS_ARE_HELPED = true

here = File.expand_path(File.dirname(__FILE__))
require "#{here}/../config/environment"
require 'spec'
require 'ostruct' # OpenStruct

#Dir[ "#{here}/spec_helpers/*.rb"].each do |helper_file|
#  require helper_file
#end

module SpecInstanceHelpers
  def assert_raise_frozen(&block)
    block.should raise_error(TypeError,/frozen/)
  end
end

Spec::Runner.configure do |config|
  config.include SpecInstanceHelpers 

  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  # 
  # For more information take a look at Spec::Example::Configuration and Spec::Runner
end

end # end ifndef. yall.
