require 'simple_barrier'

class WorkshopRoom
  include Gosu
  include CP

  constructor :mode, :screen_info, :main_window, :space_holder, :media_loader, :workshop_svg_holder do
    build_terrain
    
    @sky = @media_loader.load_image("sky.png")

    @mode.on :draw do |info|
      draw_background info
      draw_terrain info
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

  private

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
      seg.group = :terrain
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
    h = info.screen_height
    w = info.screen_width
    color = 0xffffffff
    @sky.draw_as_quad(0,0,color, w,0,color, 0,800,color, w,800,color, ZOrder::Background)
  end
end
