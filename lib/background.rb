class Background
  constructor :image do
    @width = @image.width
    @height = @image.height
  end


  def draw(info)
    viewport = info.viewport
    vleft = viewport.x * 0.33
    vwidth = viewport.width
    vtop = viewport.y * 0.33
    vheight = viewport.height

    
    x_ratio = (vwidth / @width)
    x_offset = vleft % @width
    y_ratio = (vheight / @height)
    y_offset = vtop % @height
    (x_ratio + 1).times do |i|
      x = (i*@width) - x_offset
      (y_ratio + 2).times do |j|
        y = (j*@height) - y_offset
        @image.draw(x,y,ZOrder::Background)
      end
    end

  end
end
