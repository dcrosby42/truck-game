class DebugController
  constructor(:main_window, :tractor, :media_loader, :screen_info) do
    @text = ""

    @main_window.on :update do
      @text = ""
#      build_speed_and_location
    end

    @main_window.on :draw do
#      draw_speed_and_location
    end

    @main_window.on :button_down do |id|
      if id == 17 # "t" -- find out Gosu const for this?
        @tractor.debug_cycle_image
      end
    end
  end

  private

  def ivar(obj, var_name)
    obj.instance_variable_get("@#{var_name}")
  end

  def build_speed_and_location
    @text += sprintf("Speed: %.2f\n", ivar(@tractor, :vel_mag))
    @text += sprintf("Loc:   %d,%d", ivar(@tractor, :x), ivar(@tractor, :y))
  end

  def draw_speed_and_location
    size = 20
    spacing = 2
    img = @media_loader.image_from_text(@text, Gosu::default_font_name, size, spacing, @screen_info.screen_width, :left)
    img.draw(0,0,ZOrder::Debug,1,1, 0xffffff00, :default)
  end

end
