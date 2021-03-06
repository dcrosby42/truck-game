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
      play_acceleration_sound
      play_safety_beep
      @front_wheel.body.w -= power
      @back_wheel.body.w -= power
    end
    if @dump_truck_controls.drive_right
      play_acceleration_sound
      @front_wheel.body.w += power
      @back_wheel.body.w += power
    end
    if @dump_truck_controls.brake
      play_brake_sound
      @front_wheel.body.w = 0
      @back_wheel.body.w = 0
    end
    if @dump_truck_controls.open_bucket
      unlock_bucket
      @bucket.body.apply_impulse vec2(-30_000*info.dt,0), ZeroVec2
    elsif @dump_truck_controls.close_bucket
      @bucket.body.apply_impulse vec2(10_000*info.dt,0), vec2(0,-150)
    elsif @dump_truck_controls.lock_bucket
      lock_bucket
    else
      @bucket.body.reset_forces
    end

    if @dump_truck_controls.honk
      @honk_sound.play
    end
  end

  def update_frame(info)
    play_sounds
    freefall if @frame.body.v.y > 1500
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
    @play_start_sound = true
  end

  def unlock_bucket
    if @bucket_locked
      @space_holder.space.remove_constraint(@bucket_lock_joint)
      @bucket_locked = false
    end
  end

  def lock_bucket
    unless @bucket_locked
      @space_holder.space.add_constraint(@bucket_lock_joint)
      @bucket_locked = true
    end
  end

  def add_to_shape_registry(shape_registry)
    shape_registry.add(@front_wheel.shape, @front_wheel)
    shape_registry.add(@back_wheel.shape, @back_wheel)
    shape_registry.add(@frame.shape, @frame)
    @bucket.add_to_shape_registry(shape_registry)
  end

  def remove_from_space
    @physicals.each do |p|
      p.remove_from_space
    end
    @joints.each do |j|
      @space_holder.space.remove_constraint(j)
    end
  end

  private

  def freefall
    unless @freefall
      @freefall = true
      @goofy = true
    end
  end

  WheelLayer     = 1 << 0
  TruckBodyLayer = 1 << 1

  def build_parts
    wheel_opts = {
      :radius => 27, 
      :mass => 30,
      :friction => 1.1,
      :layers => WheelLayer
    }
    @front_wheel = @physical_factory.build_circle(wheel_opts)
    @back_wheel = @physical_factory.build_circle(wheel_opts)

    @frame = @physical_factory.build_poly(
      :polygon => Polygon.new(verts_for_rect(80, 20)),
      :mass => 10,
      :layers => TruckBodyLayer,
      :collision_type => :dump_truck_frame
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

    make_pivot_joint(@front_wheel.body, @frame.body, 
                    ZeroVec2,           @front_axle)

    make_pivot_joint(@back_wheel.body, @frame.body, 
                    ZeroVec2,          @back_axle)

    bucket_local_hinge_point = @bucket.body.world2local(@bucket_hinge_point)
    bucket_local_lock_point = @bucket.body.world2local(@bucket_lock_point)

    make_pivot_joint(@bucket.body,             @frame.body, 
                     bucket_local_hinge_point, @bucket_hinge_point)

    @bucket_lock_joint = Constraint::PinJoint.new(@bucket.body,       @frame.body, 
                                                    bucket_local_lock_point, @bucket_lock_point)
    @bucket_lock_joint.dist = 0
#    @space_holder.space.add_collision_func(:zdump_bucket, :dump_truck_frame) do
#      puts "CLINK! #{Time.now}"
#    end
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
    add_and_track_joint Constraint::PivotJoint.new(a, b, anchor_a, anchor_b)
    #add_and_track_joint Joint::Pin.new(a, b, anchor_a, anchor_b)
  end

  def make_pivot_joint(a,b, anchor_a, anchor_b)
    # The docs say anchor a and anchor b are in world coords BUT I'm finding this not to be so...
    # use body-relative points for anchoring. 
    add_and_track_joint Constraint::PivotJoint.new(a, b, anchor_a, anchor_b)
  end

  def add_and_track_joint(joint)
    # @space_holder.space.add_joint(joint)
    @space_holder.space.add_constraint(joint)
    track_joint joint
    joint
  end

  def load_resources
    @wheel_image = @media_loader.load_image("truck_tire.png")
    @body_image = @media_loader.load_image("truck_cab.png")
    @engine_idle_sound = @media_loader.load_sample("truck_idle.wav")
    @acceleration_sound = @media_loader.load_sample("truck_accel_short.wav")
    @brake_sound = @media_loader.load_sample("truck_air_brake.wav")
    @start_sound = @media_loader.load_sample("truck_start.wav")
    @goofy_shriek = @media_loader.load_sample("goofyshriek.wav")
    @safety_beep = @media_loader.load_sample("truck_beep.wav")
    honk = @media_loader.load_sample("honk.wav")
    @honk_sound = SoundEffect.new(:sample => honk, :volume => 0.5)
  end

  def draw_body(info)
    loc = info.view_point(@frame.body.local2world(vec2(3,-12)))
    # angle = -90 + radians_to_gosu(@frame.body.a)
    angle = @frame.body.a.radians_to_degrees
    @body_image.draw_rot(loc.x, loc.y, ZOrder::Truck, angle)
  end

  def draw_wheel(info, wheel)
    loc = info.view_point(wheel.body.p)
    # ang = radians_to_gosu(wheel.body.a)
    ang = wheel.body.a.radians_to_gosu
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

  def play_acceleration_sound
    @play_acceleration_sound = true
  end

  def play_brake_sound
    if @frame.body.v.x.abs > 50
      @play_brake_sound = true
    end
  end

  def play_safety_beep
    @play_safety_beep = true
  end

  def play_sounds
    if @current_acceleration_sample and !@current_acceleration_sample.playing?
      @current_acceleration_sample = nil
    end
    if @current_safety_beep_sample and !@current_safety_beep_sample.playing?
      @current_safety_beep_sample = nil
    end
    if @current_idle_sample and !@current_idle_sample.playing?
      @current_idle_sample = nil
    end
    if @current_brake_sample and !@current_brake_sample.playing?
      @current_brake_sample = nil
    end

    if @play_start_sound
#      @current_brake_sample = @brake_sound.play unless @current_brake_sample
      @start_sound.play
      @play_start_sound = false
    end
    if @play_brake_sound
      @current_brake_sample = @brake_sound.play unless @current_brake_sample
      @play_brake_sound = false
    end

    if @play_acceleration_sound 
      @current_acceleration_sample = @acceleration_sound.play unless @current_acceleration_sample
      @play_acceleration_sound = false
    else
      @current_acceleration_sample.stop if @current_acceleration_sample
      @current_idle_sample = @engine_idle_sound.play(1,1) unless @current_idle_sample
    end

    if @play_safety_beep
      @current_safety_beep_sample = @safety_beep.play unless @current_safety_beep_sample
      @play_safety_beep = false
    else
      @current_safety_beep_sample.stop if @current_safety_beep_sample
    end

    if @goofy
      @goofy_shriek.play
      @goofy = false
    end
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
      ang = 270+ @body.a.radians_to_gosu
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

    def location
      @body.p
    end

    def move_to(pt)
      @body.p = pt
    end

    def add_to_shape_registry(shape_registry)
      @my_shapes.each do |sh|
        shape_registry.add(sh, self)
      end
    end
    

    def remove_from_shape_registry(shape_registry)
      @my_shapes.each do |sh|
        shape_registry.remove(sh)
      end
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

      @pin_point = vec2(-30,30) # near bottom left

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
      @my_shapes = []
      vert_lists.each do |vl|
        build_and_add_shape vl
      end
    end

    def build_and_add_shape(verts)
      shape = Shape::Poly.new(@body, verts, vec2(0,0))
      shape.layers = TruckBodyLayer
      shape.collision_type = :dump_bucket
      @my_shapes << shape
      @space.add_shape(shape)
    end

  end

end

class SoundEffect
  constructor :sample, :volume
  def setup
    @volume ||= 1.0
  end

  def play
    return if @current_sample and @current_sample.playing?
    @current_sample = @sample.play(@volume)
  end
end
