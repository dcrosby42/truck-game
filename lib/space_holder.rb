require 'chipmunk'

class SpaceHolder
  attr_reader :space

  def initialize
    @space = CP::Space.new
  end

  def step(dt=TICK)
    @space.step dt
  end
end
