class PolyBody
  include Gosu
  include CP
  include Initializer
  attr_reader :body

  Defaults = {
    :space => nil,
    :image => nil,
    :verts => nil,
    :mass => 1,
    :draw_polygon => false,
    :polygon_color => 0xffffffff,
    :collision_type => :poly_body,
    :elasticity => 0.0,
    :friction => 0.7,
    :group => nil,
    :layers => nil
  }

  def initialize(opts={})
    set_instance_variables(Defaults, opts,
                           :required => [ :space, :verts ])
    data = Defaults.merge(opts)
    @space = data[:space]
    @image = data[:image]
    @verts = data[:verts]
    @mass = data[:mass]

    moment_of_inertia = CP.moment_for_poly(@mass, @verts, ZeroVec2)
    @body = CP::Body.new(@mass, moment_of_inertia)
    @shape = CP::Shape::Poly.new(@body, @verts, ZeroVec2)
    @shape.collision_type = data[:collision_type]
    @shape.group = data[:group] if data[:group]
    @shape.layers = data[:layers] if data[:layers]
    @shape.body.p = ZeroVec2
    @shape.e = data[:elasticity]
    @shape.u = data[:friction]
    @space.add_body(@body)
    @space.add_shape(@shape)
  end

  def remove_from_space
    @space.remove_body(@body)
    @space.remove_shape(@shape)
  end

  def draw(info)
    if @image
      loc = info.view_point(@body.p)
      @image.draw_rot(loc.x, loc.y, ZOrder::Fruit, -90 + radians_to_gosu(@body.a))
    end
    if @draw_polygon
      draw_poly info
    end
  end

  def location
    @body.p
  end

  def angle_radians
    @body.a
  end

  def move_to(point)
    @body.p = point
  end

  def move_by(vec)
    @body.p += vec
  end

  private

  def draw_poly(info)
    @verts.map { |v| @body.local2world(v) }.each_edge do |a,b|
      info.window.draw_line(
        info.view_x(a.x), info.view_y(a.y), @polygon_color,
        info.view_x(b.x), info.view_y(b.y), @polygon_color,
        ZOrder::Debug)
    end
  end
end
