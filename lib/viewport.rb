class Viewport
  attr_accessor :x, :y, :width, :height

  def initialize
    @x = 0.0
    @y = 0.0
  end

  def offset_x(x)
    x - @x
  end
  alias_method :ox, :offset_x

  def offset_y(y)
    y - @y
  end
  alias_method :oy, :offset_y

  def offset_point(pt)
    pt - vec2(@x,@y)
  end

end
