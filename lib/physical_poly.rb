class PhysicalPoly
  include Initializer
  attr_reader :body, :shape, :mass, :polygon

  Defaults = {
    :space => nil,

    # Body stuff
    :location => ZeroVec2,
    :mass => 10,
    :angle => 0.0,
    :as_anchor => false,

    # Shape stuff
    :polygon => nil,
    :friction => 0.7,
    :elasticity => 0.1,
    :z_order => 1,
    :collision_type => :physical_poly,
    :group => nil,
    :layers => nil
  }

  def initialize(opts)
    set_instance_variables(Defaults,opts, :required => [ :space, :polygon ])
    @vertices = @polygon.vertices

    moment_of_inertia = nil
    if @as_anchor
      moment_of_inertia = Float::Infinity
      @mass = Float::Infinity
      @layers = 0
    else
      moment_of_inertia = CP::moment_for_poly(@mass, @vertices, vec2(0,0))
    end
    @body =  CP::Body.new(@mass, moment_of_inertia)
    @body.p = @location
    @body.a = @angle

    @shape = CP::Shape::Poly.new(@body, @vertices, vec2(0,0))
    @shape.collision_type = @collision_type
    @shape.group = @group if @group
    @shape.layers = @layers if @layers
    @shape.e = @elasticity
    @shape.u = @friction

    @space.add_body(@body) unless @as_anchor
    @space.add_shape(@shape)
  end

  def remove_from_space
    @space.remove_shape(@shape)
    @space.remove_body(@body)
  end

  def world_vertices
    @vertices.map do |v|
      @body.local2world(v)
    end
  end

  def cold_drop(loc)
    move_to loc
    @body.reset_forces
    @body.a = 0
    @body.w = 0
    @body.v = ZeroVec2
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
  alias_method :translate, :move_by
end
