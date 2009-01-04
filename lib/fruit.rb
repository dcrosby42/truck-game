class Fruit
  include Gosu
  include CP

  def initialize(opts={})
    @space = opts[:space]
    @image = opts[:image]
    @verts = opts[:verts]
    @mass = 1
    @color = 0xffffffff #debug

    moment_of_inertia = CP.moment_for_poly(@mass, @verts, ZeroVec2)
    @body = CP::Body.new(@mass, moment_of_inertia)
    @shape = CP::Shape::Poly.new(@body, @verts, ZeroVec2)
    @shape.collision_type = :fruit
    @shape.body.p = ZeroVec2
    @shape.e = 0.0
    @shape.u = 0.7
    @space.add_body(@body)
    @space.add_shape(@shape)

  end

  def remove_from_space
    @space.remove_body(@body)
    @space.remove_shape(@shape)
  end

  def draw(info)
    loc = info.view_point(@body.p)
    @image.draw_rot(loc.x, loc.y, ZOrder::Fruit, -90 + radians_to_gosu(@body.a))
#    draw_debug_poly info
  end

  def location
    @body.p
  end

  def move_to(point)
    @body.p = point
  end

  private

  def draw_debug_poly(info)
    @verts.map { |v| @body.local2world(v) }.each_edge do |a,b|
      info.window.draw_line(
        info.view_x(a.x), info.view_y(a.y), @color,
        info.view_x(b.x), info.view_y(b.y), @color,
        ZOrder::Debug)
    end
  end
end
