class Truck
  include Gosu
  include CP
  include DebugDrawing

  attr_reader :truck_controls

  constructor :main_window, :space_holder, :media_loader, :physical_factory, :simulation, :truck_controls do
    setup_tracking
    build_parts
    assemble_vehicle
    load_resources

    @simulation.on :update_space do |info|
      if @truck_controls.drive_left
        @front_wheel.body.w -= 0.3
        @back_wheel.body.w -= 0.3
      end
      if @truck_controls.drive_right
        @front_wheel.body.w += 0.3
        @back_wheel.body.w += 0.3
      end
      if @truck_controls.brake
        @front_wheel.body.w = 0
        @back_wheel.body.w = 0
      end
      if @truck_controls.open_bucket
        @bucket.body.apply_impulse vec2(-500/3.0,0), ZeroVec2
      end
      if @truck_controls.close_bucket
        @bucket.body.apply_impulse vec2(100/3.0,0), vec2(0,-150)
      end
    end
  end

#  def drive_left
#    @front_wheel.body.w -= 1
#    @back_wheel.body.w -= 1
#  end
#
#  def drive_right
#    @front_wheel.body.w += 1
#    @back_wheel.body.w += 1
#  end

#  def brake
#    @front_wheel.body.w = 0
#    @back_wheel.body.w = 0
#  end
#
#  def open_bucket
#    @bucket.body.apply_impulse vec2(-500,0), ZeroVec2
#  end
#
#  def close_bucket
#    @bucket.body.apply_impulse vec2(100,0), vec2(0,-150)
#  end

  def cold_drop(point)
    layout_parts
    move_parts point
  end

  def remove_from_space
    @physicals.each do |p|
      p.remove_from_space
    end
    @joints.each do |j|
      @space_holder.space.remove_joint(j)
    end
  end

  def draw
    draw_wheel @front_wheel
    draw_wheel @back_wheel

    draw_body

    @bucket.draw

#    draw_joints
  end

  private

  WheelLayer     = 1 << 0
  TruckBodyLayer = 1 << 1

  def build_parts
    wheel_opts = {
      :radius => 30, 
      :mass => 30,
      :friction => 1,
      :layers => WheelLayer
    }
    @front_wheel = @physical_factory.build_circle(wheel_opts)
    @back_wheel = @physical_factory.build_circle(wheel_opts)

    @frame = @physical_factory.build_poly(
      :vertices => verts_for_rect(80, 20),
      :mass => 10,
      :layers => TruckBodyLayer
    )

    @bucket = build_bucket

    @front_axle = vec2(35,20)
    @back_axle = vec2(-35,20)
    @bucket_hinge_point = vec2(-40, -10)

    track_physical @front_wheel
    track_physical @back_wheel
    track_physical @frame
    track_physical @bucket
  end


  def assemble_vehicle
    layout_parts
    make_pin_joint(@front_wheel.body, @frame.body, ZeroVec2, @front_axle)
    make_pin_joint(@back_wheel.body, @frame.body, ZeroVec2, @back_axle)
    make_pin_joint(@bucket.body, @frame.body, @bucket.inner_pin_point, @bucket_hinge_point)
  end

  def layout_parts
    @frame.cold_drop ZeroVec2
    @front_wheel.cold_drop @front_axle
    @back_wheel.cold_drop @back_axle
    @bucket.cold_drop @bucket_hinge_point - @bucket.inner_pin_point
  end

  def move_parts(point)
    @frame.body.p += point
    @front_wheel.body.p += point
    @back_wheel.body.p += point
    @bucket.body.p += point
  end

  def make_pin_joint(a,b, anchor_a, anchor_b)
    joint = Joint::Pin.new(a, b, anchor_a, anchor_b)
    @space_holder.space.add_joint(joint)
    track_joint joint
    joint
  end

  def load_resources
    @wheel_image = @media_loader.load_image("truck_tire.png")
    @body_image = @media_loader.load_image("truck_cab.png")
  end

  def draw_body
    loc = @frame.body.p + vec2(3,-12)
    angle = 270 + radians_to_gosu(@frame.body.a)
    @body_image.draw_rot(loc.x, loc.y, ZOrder::Truck, angle)
    # Debugging outline:
#    @frame.world_vertices.each_edge do |a,b|
#      @main_window.draw_line(a.x,a.y, White,
#                       b.x,b.y, White, ZOrder::Debug)
#    end
  end

#  def draw_joints
#    draw_cross_at_vec2(@main_window, @frame.body.local2world(@back_axle))
#    draw_cross_at_vec2(@main_window, @frame.body.local2world(@front_axle))
#    draw_cross_at_vec2(@main_window, @frame.body.local2world(@bucket_hinge_point))
#  end

  def draw_wheel(wheel)
    loc = wheel.body.p
    ang = radians_to_gosu(wheel.body.a)
    x = loc.x
    y = loc.y
#    draw_circle(window, x, y, ang, circle.radius)
#    draw_radius(window, circle)

    @wheel_image.draw_rot(x,y,ZOrder::TruckTire, ang)
  end

  def setup_tracking
    @joints ||= []
    @physicals ||= []
  end

  def track_joint(joint)
    @joints << joint
  end

  def track_physical(phys)
    @physicals << phys
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

  def build_bucket
    Bucket.new(:space => @space_holder.space, :media_loader => @media_loader)
  end

  class Bucket
    include Gosu
    include CP
    include DebugDrawing
    attr_reader :body

    constructor :space, :media_loader

    def setup
      create_shapes
      @bucket_image = @media_loader.load_image("dump_bucket.png")
    end

    def draw
#      draw_polygons(window)
      draw_bucket_image
    end

    def draw_polygons
      draw_poly window, @bed_verts
      draw_poly window, @gate_verts
      draw_poly window, @gate_top_verts
      draw_poly window, @front_verts
      draw_poly window, @top_verts
      draw_cross_at_vec2(@main_window, pin_point, 0xffff0000)
    end

    def draw_bucket_image
      ang = 270+ radians_to_gosu(@body.a)
      z = ZOrder::Truck
      @bucket_image.draw_rot(@body.p.x, @body.p.y, z, ang)
    end

    def inner_pin_point
      @pin_point
    end

    def pin_point
      @body.local2world(@pin_point)
    end

    def cold_drop(loc)
      @body.reset_forces
      @body.p = loc
      @body.a = 0
    end

    private
    def draw_poly(window, local_verts)
      local_verts.map { |v| @body.local2world(v) }.each_edge do |a,b|
        window.draw_line(a.x,a.y, 0xffffffff,
                         b.x,b.y, 0xffffffff, ZOrder::Debug)
      end
    end

    def create_shapes
      @gate_verts = [
        vec2(-50,15), # bottom left
        vec2(-35,15), # bottom right
        vec2(-60,-5), # top right
        vec2(-75,-5), # top left
      ]
      @gate_top_verts = [
        vec2(-75,-5), # bottom left
        vec2(-60,-5), # bottom right
        vec2(-60,-15), # top right
        vec2(-75,-15), # top left
      ]

      @bed_verts = [
        vec2(-50,30),
        vec2(30,30),
        vec2(30,15),
        vec2(-50,15),
      ]

      @pin_point = vec2(-30,30)

      @front_verts = [
        vec2(0,15),    # bottom left
        vec2(30,15),   # bottom right
        vec2(60,-28),  # top right
        vec2(30,-24),  # top left
      ]

      @top_verts = [
        vec2(55,-10),    # bottom left
        vec2(70,-10),   # bottom right
        vec2(70,-28),  # top right
        vec2(55,-28),  # top left
      ]

      mass = 5
      moment = moment_for_poly(mass, @bed_verts, ZeroVec2)
      @body = Body.new(mass, moment)
      
      build_and_add_shapes(
        @gate_verts,
        @gate_top_verts,
        @bed_verts,
        @front_verts,
        @top_verts
      )

      @space.add_body(@body)
    end

    def build_and_add_shapes(*vert_lists)
      vert_lists.each do |vl|
        build_and_add_shape vl
      end
    end

    def build_and_add_shape(verts)
      shape = Shape::Poly.new(@body, verts, vec2(0,0))
      shape.layers = TruckBodyLayer
      @space.add_shape(shape)
    end

  end

end
