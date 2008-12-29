require 'chipmunk'

class SpaceHolder
  attr_reader :space

  GRAVITY = 900
  DAMPING = 0.7
  TICK = 1.0 / 60.0 

  def initialize
    @space = CP::Space.new
    @space.iterations = 5
    @space.damping = DAMPING
    @space.gravity = vec2(0,GRAVITY)
  end

  def step(dt=TICK)
    @space.step dt
  end


end
