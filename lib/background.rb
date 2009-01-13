class Background
  constructor :image

  def draw(info)
    h = info.screen_height
    w = info.screen_width
    color = 0xffffffff
    @image.draw_as_quad(0,0,color, 
                        w,0,color, 
                        0,800,color, 
                        w,800,color, 
                        ZOrder::Background)
  end
end
