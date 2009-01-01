class PhysicalPoly
  attr_reader :body, :shape, :mass

  Defaults = {
    # Body stuff
    :location => ZeroVec2,
    :mass => 50,
    :angle => 0.0,
    # Shape stuff
    :vertices => [],
    :friction => 0.7,
    :elast => 0.1,
    :z_order => 1,
    :radius => 10,
    :collision_type => :poly,
  }

  def initialize(opts)
    opts = Defaults.merge(opts)
    @vertices = opts[:vertices]
    @mass = opts[:mass]
    @group = opts[:group]

    moment_of_inertia = CP::moment_for_poly(@mass, @vertices, vec2(0,0))
    @body =  CP::Body.new(@mass, moment_of_inertia)
    @body.p = opts[:location]
    @body.a = opts[:angle]

    @shape = CP::Shape::Poly.new(@body, @vertices, vec2(0,0))
    @shape.collision_type = opts[:collision_type]
    @shape.group = opts[:group] if opts[:group]
    @shape.layers = opts[:layers] if opts[:layers]
    @shape.e = opts[:elast]
    @shape.u = opts[:friction]

    @space = opts[:space]
    @space.add_body(@body)
    @space.add_shape(@shape)
  end

  def remove_from_space
    @space.remove_shape(@shape)
    @space.remove_body(@body)
  end

  def local_vertices
    @vertices
  end

  def world_vertices
    @vertices.map do |v|
      @body.local2world(v)
    end
  end

  def cold_drop(loc)
    @body.reset_forces
    @body.p = loc
    @body.a = 0
  end
end
