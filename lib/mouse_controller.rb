require 'gosu'
require 'debug_drawing'

class MouseController
  constructor :simulation, :media_loader, :space_holder, :shape_registry

  def setup
    @cursor = Cursor.new(:icon => @media_loader.load_image("mouse_pointer.png"))
    @dragging = nil
    @dragging_offset = ZeroVec2

    @simulation.on :update_frame do |info|
      @cursor.screen_position = info.view_mouse_point

      if info.button_down?(Gosu::Button::MsLeft)
        mpt = info.world_mouse_point
        @clicked = mpt
        if @dragging
          drag mpt
        else
          start_dragging mpt
        end
      elsif @dragging
        let_go mpt
      end
    end

    @simulation.on :update_space do |info|
      if @dragging
        drag2 info.dt
      end
    end

    @simulation.on :draw_frame do |info|
      @cursor.draw(info)
#      DebugDrawing.draw_cross_at_vec2(info.window, info.view_point(@clicked)) if @clicked
    end
  end

  def start_dragging(pt)
    @space_holder.space.shape_point_query(pt) do |shape|
      obj = @shape_registry.lookup(shape)
      if obj
        @dragged = obj
        @space_holder.space.remove_body @dragged.body
        @dragging = pt
        @dragging_offset = obj.location - pt
      end
    end
  end

  def drag(pt)
    @drag_dest = pt + @dragging_offset
  end

  def drag2(dt)
    return unless @drag_dest
    @dragged.body.update_velocity(ZeroVec2,0,dt)
    @dragged.move_to(@drag_dest)
    @dragged.body.update_position(dt)
  end

  def let_go(pt)
    @dragging = nil
    @drag_dest = nil
    @dragging_offset = ZeroVec2
    @space_holder.space.add_body @dragged.body
    @dragged = nil
  end

  class Cursor
    constructor :icon 
    attr_accessor :screen_position

    def draw(info)
      @icon.draw(@screen_position.x, @screen_position.y, ZOrder::MousePointer)
    end
  end
end

