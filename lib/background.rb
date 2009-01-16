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
#    bottom = top+viewport.height
#    right = left+viewport.width

    
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

#    (1 + (vwidth / @width)).times do |i|
#      x = -(vleft % @width)

#    y = (vtop / @height
    
#    bottom = info.screen_height
#    right = info.screen_width
#    h = info.screen_height
#    w = info.screen_width
#    @image.draw_as_quad(0,0,color, 
#                        w,0,color, 
#                        0,800,color, 
#                        w,800,color, 
#                        ZOrder::Background)
  end
end
