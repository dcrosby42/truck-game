class Picture
  attr_reader :bounds, :center
  constructor :image, :bounds, :z_order 

  def center
    @bounds.center
  end

  def draw(info)
    x = info.view_x(@bounds.x)
    y = info.view_y(@bounds.y)
    @image.draw(x, y, @z_order)
  end
end
