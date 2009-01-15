class DumpTruck
  include Gosu
  include CP
  include DebugDrawing

  attr_reader :dump_truck_controls

  constructor :space_holder, :media_loader, :physical_factory, :dump_truck_controls do
    setup_tracking
    build_parts
    assemble_vehicle
    lock_bucket
    load_resources
  end

  def update_space(info)
    power = 60 * info.dt
    if @dump_truck_controls.boost
      @frame.body.apply_impulse vec2(100_000*info.dt,400), ZeroVec2
    end
    if @dump_truck_controls.drive_left
      @front_wheel.body.w -= power
      @back_wheel.body.w -= power
    end
    if @dump_truck_controls.drive_right
      @front_wheel.body.w += power
      @back_wheel.body.w += power
    end
    if @dump_truck_controls.brake
      @front_wheel.body.w = 0
      @back_wheel.body.w = 0
    end
    if @dump_truck_controls.open_bucket
      unlock_bucket
      @bucket.body.apply_impulse vec2(-30_000*info.dt,0), ZeroVec2
#        @bucket.body.apply_force vec2(-30_000*info.dt,0), ZeroVec2
    elsif @dump_truck_controls.close_bucket
      @bucket.body.apply_impulse vec2(10_000*info.dt,0), vec2(0,-150)
#        @bucket.body.apply_force vec2(10_000*info.dt,0), vec2(0,-150)
    elsif @dump_truck_controls.lock_bucket
      lock_bucket
    else
      @bucket.body.reset_forces
    end
  end

  def draw(info)
    draw_wheel info, @front_wheel
    draw_wheel info, @back_wheel
    draw_body info
    @bucket.draw info
  end

  def location
    @frame.body.p
  end

  def cold_drop(point)
    layout_parts
    move_parts point
  end

  def unlock_bucket
    if @bucket_locked
      @space_holder.space.remove_joint(@bucket_lock_joint)
      @bucket_locked = false
    end
  end

  def lock_bucket
    unless @bucket_locked
      @space_holder.space.add_joint(@bucket_lock_joint)
      @bucket_locked = true
    end
  end

  def remove_from_space
    @physicals.each do |p|
      p.remove_from_space
    end
    @joints.each do |j|
      @space_holder.space.remove_joint(j)
    end
  end


  private

  WheelLayer     = 1 << 0
  TruckBodyLayer = 1 << 1

  def build_parts
    wheel_opts = {
      :radius => 30, 
      :mass => 30,
      :friction => 1.1,
      :layers => WheelLayer
    }
    @front_wheel = @physical_factory.build_circle(wheel_opts)
    @back_wheel = @physical_factory.build_circle(wheel_opts)

    @frame = @physical_factory.build_poly(
      :polygon => Polygon.new(verts_for_rect(80, 20)),
      :mass => 10,
      :layers => TruckBodyLayer
    )

    @bucket = build_bucket

    @front_axle = vec2(35,20)
    @back_axle = vec2(-35,20)
    @bucket_hinge_point = vec2(-40, -10)
    @bucket_lock_point = vec2(20, 0)

    track_physical @front_wheel
    track_physical @back_wheel
    track_physical @frame
    track_physical @bucket
  end


  def assemble_vehicle
    layout_parts
    make_pivot_joint(@front_wheel.body, @frame.body, @front_axle)
    make_pivot_joint(@back_wheel.body, @frame.body, @back_axle)
    make_pivot_joint(@bucket.body, @frame.body, @bucket_hinge_point)
    @bucket_lock_joint = Joint::Pivot.new(@bucket.body, @frame.body, @bucket_lock_point)
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
    add_and_track_joint Joint::Pin.new(a, b, anchor_a, anchor_b)
  end

  def make_pivot_joint(a,b, loc)
    add_and_track_joint Joint::Pivot.new(a, b, loc)
  end

  def add_and_track_joint(joint)
    @space_holder.space.add_joint(joint)
    track_joint joint
    joint
  end

  def load_resources
    @wheel_image = @media_loader.load_image("truck_tire.png")
    @body_image = @media_loader.load_image("truck_cab.png")
  end

  def draw_body(info)
    loc = info.view_point(@frame.body.local2world(vec2(3,-12)))
    angle = -90 + radians_to_gosu(@frame.body.a)
    @body_image.draw_rot(loc.x, loc.y, ZOrder::Truck, angle)
  end

  def draw_wheel(info, wheel)
    loc = info.view_point(wheel.body.p)
    ang = radians_to_gosu(wheel.body.a)
    x = loc.x
    y = loc.y
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

    def draw(info)
#      draw_polygons(window)
      draw_bucket_image info
    end

#    def draw_polygons
#      draw_poly window, @bed_verts
#      draw_poly window, @gate_verts
#      draw_poly window, @gate_top_verts
#      draw_poly window, @front_verts
#      draw_poly window, @top_verts
#      draw_cross_at_vec2(@main_window, pin_point, 0xffff0000)
#    end

    def draw_bucket_image(info)
      ang = 270+ radians_to_gosu(@body.a)
      z = ZOrder::Truck
      loc = info.view_point(@body.p)
      @bucket_image.draw_rot(loc.x, loc.y, z, ang)
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
      @body.w = 0
      @body.v = ZeroVec2
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
