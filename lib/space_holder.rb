require 'chipmunk'

class SpaceHolder
  attr_accessor :space

  def step(dt=TICK)
    @space.step dt
  end
end
