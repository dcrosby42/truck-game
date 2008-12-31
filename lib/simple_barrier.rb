require 'initializer'

class SimpleBarrier
  include Initializer

  Defaults = {
    :location => vec2(0,0),
    :angle => 0.0,
    :length => 1.0,
    :thickness => 0.0,
    :friction => 0.7,
    :elast => 0.1,
    :color => 0xffffffff,
    :z_order => ZOrder::Debug,
    :space => nil,
    :collision_tag => :barrier
  }

  def initialize(opts={})
    set_instance_variables(Defaults, opts, :required => [:space])
    create_shape 
  end

  def draw(window)
    a = @body.local2world(@body_start)
    b = @body.local2world(@body_end)
    window.draw_line(a.x, a.y, @color, 
                      b.x, b.y, @color, 
                      @z_order, :default)
  end

  def x
    @body.local2world(@body_start).x
  end

  def y
    @body.local2world(@body_start).y
  end

  private

  def create_shape
    moment_of_inertia, mass = Float::Infinity, Float::Infinity
    @body = CP::Body.new(mass, moment_of_inertia)
    @body.p = @location
    @body.a = @angle
    @body_start = vec2(0,0)
    @body_end = vec2(@length,0)

    @shape = CP::Shape::Segment.new(@body, @body_start, @body_end, @thickness) 
    @shape.collision_type = @collision_tag
    @shape.e = @elast
    @shape.u = @friction

    @space.add_shape(@shape)
  end
end
