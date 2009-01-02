require 'simple_barrier'

class WorkshopRoom
  include Gosu
  include CP

  constructor :mode, :screen_info, :main_window, :space_holder, :media_loader, :workshop_svg_holder do
#    build_floor
    build_terrain

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
#    @drawables.each do |d|
#      d.draw info
#    end
    draw_terrain(info)
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
      :angle => gosu_to_radians(45),
      :length => 200,
      :space => @space_holder.space
    )
    @drawables << @right_ramp

    @left_ramp = create_barrier(
      :location => vec2(50, win_height-50),
      :angle => gosu_to_radians(-45),
      :length => 200,
      :space => @space_holder.space
    )
    @drawables << @left_ramp

    @right_dock = create_barrier(
      :location => @right_ramp.world_end_point,
      :angle => 0,
      :length => 600,
      :space => @space_holder.space
    )
    @drawables << @right_dock

    @right_dock_end = create_barrier(
      :location => @right_dock.world_end_point,
      :angle => gosu_to_radians(0),
      :length => 50,
      :space => @space_holder.space
    )
    @drawables << @right_dock_end

    @left_dock = create_barrier(
      :location => @left_ramp.world_end_point,
      :angle => gosu_to_radians(-90),
      :length => 600,
      :space => @space_holder.space
    )
    @drawables << @left_dock
    @left_dock_end = create_barrier(
      :location => @left_dock.world_end_point,
      :angle => gosu_to_radians(0),
      :length => 50,
      :space => @space_holder.space
    )
    @drawables << @left_dock_end

  end

  def create_barrier(opts)
    SimpleBarrier.new(opts)
  end

  def build_terrain
    g = @workshop_svg_holder.get_layer("ground")
    @terrain_verts = g.path.vertices
    
    moment_of_inertia,mass = Float::Infinity,Float::Infinity
    elasticity = 0.1
    friction = 0.7
    thickness = 0.5
    @terrain_body = Body.new(mass,moment_of_inertia)
    @terrain_verts.each_segment do |a,b|
      seg = Shape::Segment.new(@terrain_body, a,b, thickness)
      seg.collision_type = :terrain
      seg.e = elasticity
      seg.u = friction
      @space_holder.space.add_shape(seg)
    end
  end

  def draw_terrain(info)
    color = 0xff336633
    top_color = color
    bottom_color = 0xff333300

    bottom = 800
    @terrain_verts.each_segment do |a,b|
      a = info.view_point(a)
      b = info.view_point(b)

#      info.window.draw_line(
#        a.x, a.y, color, 
#        b.x, b.y, color, 
#        ZOrder::Debug)
      info.window.draw_quad(
        a.x,a.y, top_color,
        b.x,b.y, top_color,
        a.x,bottom, bottom_color, 
        b.x,bottom, bottom_color, 
        ZOrder::Background)
    end
  end

  def draw_background(info)
    window = info.window
    h = info.screen_height
    w = info.screen_width
    light_blue = 0xFF9999DD
    dark_blue = 0xFF000066
    top_color = light_blue
    bottom_color = dark_blue

    @media_loader.load_image("sky.png").draw_as_quad(0,0,top_color, w,0,top_color, 0,800,top_color, w,800,top_color, ZOrder::Background)

#    window.draw_quad(0,0,top_color, w,0,top_color, 0,800,bottom_color, w,800,bottom_color, ZOrder::Background)
    #
#    window.draw_quad(0,0,top_color, w,0,top_color, 0,h-50,bottom_color, w,h-50,bottom_color, ZOrder::Background)

#    grass_green = 0xFF5EBD57 
#    dirt_brown = 0xFF4A4431
#    top_color = dirt_brown
#    bottom_color = grass_green

#    left = info.view_x(0)
#    right = info.view_x(w)
#    top = info.view_y(h-50)
#    bottom = info.view_y(h)
#
#    window.draw_quad(left,top, top_color, 
#                     right,top, top_color, 
#                     left,bottom, bottom_color, 
#                     right,bottom, bottom_color, 
#                     ZOrder::Background)
  end
end
