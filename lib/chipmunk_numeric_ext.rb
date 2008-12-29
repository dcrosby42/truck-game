require 'chipmunk'

class Numeric 
  def radians_to_vec2
    vec2(Math::cos(self), Math::sin(self))
  end
end

class Float
  Infinity = 1.0/0.0
end

ZeroVec2 = vec2(0,0)
