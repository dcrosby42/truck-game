class ItemCounter
  attr_accessor :item_image
  attr_accessor :x, :y, :item_x, :item_y, :text_x, :text_y
  
  constructor :screen_info, :media_loader do
    @bg_image = @media_loader.load_image("item-counter-bg.png")

    @counter_font = @media_loader.load_default_font(50)
    @counter_font_color = 0xffffff00

    @x = 5
    @y = @screen_info.screen_height - @bg_image.height - 5

    @item_x = @x + 45 
    @item_y = @y + 35

    @text_x = @x + 120
    @text_y = @y + 45
  end

  def draw(count_string)
    @bg_image.draw(@x,@y,ZOrder::GuiWidgets)

    @item_image.draw(@item_x - @item_image.width / 2,@item_y - @item_image.height/2, ZOrder::GuiWidgets)
    
    @counter_font.draw_rel(count_string,
                           @text_x + 5, @text_y + 5, ZOrder::GuiText,
                           0.5, 0.5,
                           1,1,
                           0xaa000000)

    @counter_font.draw_rel(count_string,
                           @text_x, @text_y, ZOrder::GuiText,
                           0.5, 0.5,
                           1,1,
                           @counter_font_color)
  end

end
