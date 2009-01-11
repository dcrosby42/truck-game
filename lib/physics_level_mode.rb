require 'level_mode'

class PhysicsLevelMode < LevelMode
  constructor :space_holder

  GRAVITY = 900
  DAMPING = 0.7 

  def setup_level
    space = CP::Space.new
    space.iterations = 5
    space.damping = DAMPING
    space.gravity = vec2(0,GRAVITY)
    @space_holder.space = space
  end
end
