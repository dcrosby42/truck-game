def draw_cross(window, pt, color=0xffff0000)
  window.draw_line(pt.x,pt.y,color,
                   pt.x,pt.y-5,color)
  window.draw_line(pt.x,pt.y,color,
                   pt.x+5,pt.y,color)
end

class TruckController
  include Gosu
  include CP

  White = 0xffffffff

  constructor :mode, :physical_factory, :space_holder do
    build_shapes

    @mode.on :draw do |info| 
      draw info.window
    end

    @mode.on :update do |info|
      if info.button_down?(Button::KbLeft)
        drive_left
      elsif info.button_down?(Button::KbRight)
        drive_right
      elsif info.button_down?(Button::KbDown)
        brake
      elsif info.button_down?(Button::KbA)
        bucket_left
      elsif info.button_down?(Button::KbD)
        bucket_right
      end
    end
  end

  def draw(window)
    draw_wheel(window, @front_wheel)
    draw_wheel(window, @back_wheel)
    @frame.world_vertices.each_edge do |a,b|
      window.draw_line(a.x,a.y, White,
                       b.x,b.y, White)
    end
    @bucket.draw(window)

#    draw_cross(window, @frame.body.local2world(@back_axle))
#    draw_cross(window, @frame.body.local2world(@front_axle))
#    draw_cross(window, @frame.body.local2world(@bucket_hinge_point))
  end

  private

  WheelLayer     = 1 << 0
  TruckBodyLayer = 1 << 1

  def build_shapes
    wheel_opts = {
      :radius => 30, 
      :mass => 30,
      :layers => WheelLayer,
      :collision_type => :truck_tire
    }
    @front_wheel = @physical_factory.build_circle(wheel_opts)
    @back_wheel = @physical_factory.build_circle(wheel_opts)

    frame_size = 100.0
    @frame = @physical_factory.build_poly(
      :vertices => verts_for_rect(frame_size, 10),
      :mass => 10,
      :layers => TruckBodyLayer
    )

    @bucket = build_bucket

#    @hinge = @physical_factory.build_circle(
#      :radius => 10,
#      :mass => 10,
#      :layers => 1,
      
    # Layout the parts and pin them together.
    # Pin joints have an anchor in either body.  The anchors will maintain their
    # distance from one another.  The distance is determined by the relative positions
    # of the anchors at the time the Pin is instantiated.
    near_end = (frame_size / 2) - 5
    @front_axle = vec2(near_end,0)
    @back_axle = vec2(0-near_end,0)
    @bucket_hinge_point = @back_axle + vec2(0,-5)

    @frame.body.p = ZeroVec2

    @front_wheel.body.p = @front_axle
    front_pin = Joint::Pin.new(@front_wheel.body, @frame.body, ZeroVec2, @front_axle)
    @space_holder.space.add_joint(front_pin)

    @back_wheel.body.p = @back_axle
    back_pin = Joint::Pin.new(@back_wheel.body, @frame.body, ZeroVec2, @back_axle)
    @space_holder.space.add_joint(back_pin)

    # @bucket_hinge_point is in frame-local coords, but since frame is sitting on world
    # 0,0, it can also be used as world.  @bucket is NOT centered on world 0,0 so
    # pay attention to it's anchor (local coords) versus its initial positioning 
    # (world coords).
    @bucket.body.p = @bucket_hinge_point + vec2(75,-45)*0.66 
    bucket_pin = Joint::Pin.new(@bucket.body, @frame.body, @bucket.inner_pin_point, @bucket_hinge_point)
    @space_holder.space.add_joint(bucket_pin)

    # Move the vehicle out where we can see it
    move = vec2(300,300)
    @front_wheel.body.p += move
    @back_wheel.body.p += move
    @frame.body.p += move
    @bucket.body.p += move

    @space_holder.space.resize_active_hash(100,100)
  end

  def build_bucket
    Bucket.new(@space_holder.space)
  end

  def verts_for_rect(width,height)
    top = 0.0 - height/2
    bottom = height/2
    right = width/2
    left = 0.0 - width/2
    [
      vec2( left,  top    ),
      vec2( left,  bottom ),
      vec2( right, bottom ),
      vec2( right, top    ),
    ]
  end

  def draw_wheel(window,circle)
    draw_circle(window, circle.body.p.x, circle.body.p.y, circle.body.a, circle.radius)
    draw_radius(window, circle)
  end

  def draw_radius(window,circle)
    angle = radians_to_gosu(circle.body.a)
    loc = circle.body.p
    ex = loc.x + offset_x(angle, circle.radius)
    ey = loc.y + offset_y(angle, circle.radius)
    window.draw_line(loc.x,loc.y,White, ex,ey,White)
  end

  def draw_circle(window, x,y,ang,r,color=0xffffffff,z=0,mode=:default,circle_step=10)
    ang = radians_to_gosu(ang)
    0.step(360, circle_step) { |a1| 
      a1 += ang
      a2 = a1 + circle_step
      window.draw_line(x + offset_x(a1, r), y + offset_y(a1, r), color, 
                       x + offset_x(a2, r), y + offset_y(a2, r), color, z, mode)
    }
  end

  def drive_left
    @front_wheel.body.w -= 1
    @back_wheel.body.w -= 1
  end

  def drive_right
    @front_wheel.body.w += 1
    @back_wheel.body.w += 1
  end

  def brake
    @front_wheel.body.w = 0
    @back_wheel.body.w = 0
  end

  def bucket_left
    @bucket.body.apply_impulse vec2(-500,0), ZeroVec2
#    @bucket.body.w -= 2
  end

  def bucket_right
    @bucket.body.apply_impulse vec2(500,0), vec2(0,-150)
#    @bucket.body.w += 1
  end

  class Bucket
    include Gosu
    include CP
    attr_reader :body

    def initialize(space)
      @space = space
      create_shapes
    end

    def draw(window)
      draw_poly window, @bed_verts
      draw_poly window, @gate_verts
      draw_poly window, @front_verts

#      draw_cross(window, pin_point, 0xffff0000)
    end

    def inner_pin_point
      @pin_point
    end

    def pin_point
      @body.local2world(@pin_point)
    end

    private
    def draw_poly(window, local_verts)
      local_verts.map { |v| @body.local2world(v) }.each_edge do |a,b|
        window.draw_line(a.x,a.y, White,
                         b.x,b.y, White)
      end
    end

    def create_shapes
      @gate_verts = [
        vec2(-75,35),
        vec2(-65,35),
        vec2(-65,-45),
        vec2(-75,-45),
      ].map { |v| v * 0.66 }

      @bed_verts = [
        vec2(-75,45),
        vec2(75,45),
        vec2(75,35),
        vec2(-75,35),
      ].map { |v| v * 0.66 }

      @pin_point = @bed_verts[0]

      @front_verts = [
        vec2(65,35),
        vec2(75,35),
        vec2(75,-45),
        vec2(65,-45),
      ].map { |v| v * 0.66 }

      center = vec2(0,0)
      mass = 5
      moment = moment_for_poly(mass, @bed_verts, center)
#      mass,moment = Float::Infinity, Float::Infinity
      @body = Body.new(mass, moment)
      
      @gate = Shape::Poly.new(@body, @gate_verts, vec2(0,0))
      @gate.layers = TruckBodyLayer
#      @gate.group = :truck
      @bed = Shape::Poly.new(@body, @bed_verts, vec2(0,0))
      @bed.layers = TruckBodyLayer
#      @bed.group = :truck
      @front = Shape::Poly.new(@body, @front_verts, vec2(0,0))
      @front.layers = TruckBodyLayer
#      @front.group = :truck

      @space.add_body(@body)
      @space.add_shape(@gate)
      @space.add_shape(@bed)
      @space.add_shape(@front)
    end

  end

end
