require 'simple_barrier'

class WorkshopRoom
  constructor :mode, :screen_info, :main_window, :space_holder do
    build_floor

    @mode.on :draw do |info|
      draw info
    end

    # Level control
    @mode.on :button_down do |id,info|
      case id
      when Gosu::Button::KbEscape
        @mode.abort_level
      when Gosu::Button::KbF1
        @mode.complete_level
      end
    end
  end

  def draw(info)
    draw_background info
    @drawables.each do |d|
      d.draw info
    end
  end

  private

  def build_floor
    win_height = @screen_info.screen_height
    win_width = @screen_info.screen_width

    @drawables = []

    @floor = create_barrier(
      :location => vec2(50, win_height-50),
      :angle => 0,
      :length => win_width - (50*2),
      :space => @space_holder.space
    )
#    @drawables << @floor
    @right_ramp = create_barrier(
      :location => vec2(win_width-50, win_height-50),
      :angle => -45,
      :length => 200,
      :space => @space_holder.space
    )
    @drawables << @right_ramp

    @left_ramp = create_barrier(
      :location => vec2(50, win_height-50),
      :angle => 180,
      :length => 200,
      :space => @space_holder.space
    )
    @drawables << @left_ramp

    @right_dock = create_barrier(
      :location => vec2(50, win_height-50),
      :angle => 180,
      :length => 200,
      :space => @space_holder.space
    )
    @drawables << @left_ramp

  end

  def create_barrier(opts)
    SimpleBarrier.new(opts)
  end

  def draw_background(info)
    window = info.window
    h = info.screen_height
    w = info.screen_width
    light_blue = 0xFF9999DD
    dark_blue = 0xFF000066
    top_color = light_blue
    bottom_color = dark_blue
    window.draw_quad(0,0,top_color, w,0,top_color, 0,h-50,bottom_color, w,h-50,bottom_color, ZOrder::Background)

    grass_green = 0xFF5EBD57 
    dirt_brown = 0xFF4A4431
    top_color = dirt_brown
    bottom_color = grass_green

    left = info.view_x(0)
    right = info.view_x(w)
    top = info.view_y(h-50)
    bottom = info.view_y(h)

    window.draw_quad(left,top, top_color, 
                     right,top, top_color, 
                     left,bottom, bottom_color, 
                     right,bottom, bottom_color, 
                     ZOrder::Background)
  end
end
