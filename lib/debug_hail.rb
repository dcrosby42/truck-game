#require 'rubygems'
#require 'RMagick'
require 'chipmunk'
require 'chipmunk_numeric_ext'

class DebugHail

  constructor :screen_info, :media_loader, :mode, :space_holder, :viewport do
    setup_boxes

    @mode.on :button_up do |id, info|
      case id.gosu_letter
      when 'h'
        start_hail
      end
      if info.button_down? Gosu::KbSpace
#        start_spread
      end
    end

    @mode.on :draw do |info|
      @active_boxes.each do |box|
        box.draw
      end
    end
    
  end

  private

  def setup_boxes
    @boxes = []
    count = @screen_info.screen_width / 40
    count.times do |i|
      box = Box.new(@media_loader, @viewport)
      @boxes << box
    end
    @active_boxes = []
  end

  def start_hail
    @active_boxes.each do |box|
      box.remove_self_from_space
    end
    @active_boxes = @boxes.dup
    @active_boxes.each_with_index do |box,i|
      box.place_cold(@viewport.x + i*40, 0)
      box.add_self_to_space(@space_holder.space)
    end
  end

  def start_spread
    @active_boxes.each do |box|
      box.remove_self_from_space
    end
    @active_boxes = @boxes.dup
    @active_boxes.each_with_index do |box,i|
      box.add_self_to_space(@space_holder.space)
      box.body.p = CP::Vec2.new(@viewport.x + rand*50, @viewport.y + 300+rand*50)
      box.body.v = CP::Vec2.new(1,0) * 400
    end
  end

#  def kill_offscreen_boxes
#    @active_boxes.reject! do |box|
#      if box.body.p.y > @screen_info.screen_height
#        box.remove_self_from_space
#        true
#      else
#        false
#      end
#    end
#  end

  class Box
    attr_reader :body, :shape

    NumEdges = 5
    EdgeSize = 30

    def initialize(media_loader, viewport)
      @media_loader = media_loader
      @viewport = viewport
      
      num_edges = 5
      edge_size = 25
      if rand * 100 < 50
        @image = @media_loader.load_image("corn-small.png")
        num_edges = 5
        edge_size = 25
      else
        @image = @media_loader.load_image("hay-bail-small.png")
        num_edges = 4
        edge_size = 30
      end

      points = polygon_vertices(num_edges, edge_size)
#      @debug_image = polygon_image(points, edge_size)
      @body, @shape = polygon_body_and_shape(points)
    end

    def draw
#      @debug_image.draw_rot(@body.p.x, @body.p.y, ZOrder::Background, @body.a.radians_to_gosu)
      @image.draw_rot(@viewport.ox(@body.p.x), @viewport.oy(@body.p.y), ZOrder::Background, @body.a.radians_to_gosu)
    end

    def place_cold(x,y)
      @body.p = CP::Vec2.new(x,y)
      @body.v = CP::Vec2.new(0,0)
      @body.f = CP::Vec2.new(0,0)
      @body.a = 0
      @body.w = 0
      @body.t = 0
    end

    def add_self_to_space(space)
      @space = space
      @space.add_body(body)
      @space.add_shape(shape)
    end

    def remove_self_from_space
      @space.remove_body(body)
      @space.remove_shape(shape)
    end

    private
    def polygon_vertices(sides, size)
      vertices = []
      sides.times do |i|
        angle = -2 * Math::PI * i / sides
        vertices << angle.radians_to_vec2() * size
      end
      return vertices
    end

    def polygon_image(vertices, edge_size)
      box_image = Magick::Image.new(edge_size  * 2+2, edge_size * 2+2) do
        self.background_color = 'transparent' 
      end
      gc = Magick::Draw.new
      gc.stroke('green')
      gc.stroke_width = 2
      gc.fill('yellow')
      draw_vertices = vertices.map do |v| 
        [
          v.x + edge_size, 
          v.y + edge_size
        ] 
      end.flatten

      gc.polygon(*draw_vertices)
      gc.draw(box_image)
      @media_loader.rmagick_to_gosu_image(box_image)
    end

    def polygon_body_and_shape(vertices)
      body = CP::Body.new(
                          1, # mass
                          CP::moment_for_poly(1.0, vertices, CP::Vec2.new(0, 0))) # moment of inertia
      body.p = CP::Vec2.new(0,0)
      shape = CP::Shape::Poly.new(body, vertices, CP::Vec2.new(0, 0))
      shape.e = 0.5
      shape.u = 0.4
#      @space.add_body(body)
#      @space.add_shape(shape)      
      [ body, shape ]
    end

  end

end
