class Zone
  def initialize(rectangle)
    @rectangle = rectangle
    @center_x = @rectangle.center.x
    @center_y = @rectangle.center.y
    @radius = @rectangle.width / 2.0
  end

  def contains?(thing)
    contains_point?(thing.location)
  end

  def contains_point?(loc)
    Gosu::distance(@center_x,@center_y, loc.x, loc.y) <= @radius
  end

  def draw(info)
    top = info.view_y(@rectangle.y)
    bottom = top + @rectangle.height
    left = info.view_x(@rectangle.x)
    right = left + @rectangle.width
    color = 0x660000ff
    info.window.draw_quad(left,top,color,
                          right,top,color,
                          left,bottom,color,
                          right,bottom,color,
                          ZOrder::Debug)
  end
end
