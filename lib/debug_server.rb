require 'drb'
require 'delegate'

class DebugServer
  include DRb::DRbUndumped 

  attr_accessor :level_context

  def start
    DRb.start_service("druby://0.0.0.0:#{DEBUG_SERVER_PORT}", self)
  end

  def ping
    "pong"
  end

end
