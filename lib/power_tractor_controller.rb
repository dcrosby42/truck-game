class PowerTractorController

  constructor :mode, :viewport, :space_holder, :media_loader do
    setup_chassis_and_wheels 

    @mode.on :draw do
      draw_chassis_and_wheels
    end

    @mode.on :update do |info|
      update_wheels info
      center_viewport
    end

    @mode.on :button_up do |id,info|
      if Gosu::KbUp == id
        stop_vehicle
        place_vehicle vec(@chassis.p.x, @chassis.p.y - 100)
      end
    end
  end

  private

  def update_wheels(info)
    if info.button_down? Gosu::KbRight
      input_power = -3.0
    else
      input_power = 0.0
    end

    substeps = 3
    
    dt = 1.0 / 60 / substeps

    substeps.times do 
      @chassis.reset_forces
      @back_wheel.reset_forces
      @front_wheel.reset_forces

      max_w = -100
      delta_torque = 9000 * [(@back_wheel.w - input_power * max_w)/max_w, 1].min

      @back_wheel.t += delta_torque
      @chassis.t -= delta_torque / 2

#        (body_a, body_b, anchor_point_a, anchor_point_b, rest_length, k, damping, dt)
#        k: spring constance (force/distance)
      CP::damped_spring(@chassis, @back_wheel, vec(-40,-40), vec(0,0), 70, 400, 15, dt)
      CP::damped_spring(@chassis, @front_wheel, vec(40,-40), vec(0,0), 70, 400, 15, dt)

      @space_holder.step dt
    end

  end

  def center_viewport
    @viewport.x = @chassis.p.x - 500
    @viewport.y = @chassis.p.y - 350
  end

  def stop_vehicle
    [ @front_wheel, @back_wheel, @chassis ].each do |body|
      body.reset_forces # this gets f and t, leaves p,v,a,w
      body.v = vec(0,0)
      body.a = 0
      body.w = 0
    end
  end

  def place_vehicle(pos)
    stop_vehicle
    @chassis.p = pos
    @back_wheel.p = pos + vec(-40,30)
    @front_wheel.p = pos + vec(40,30)
  end

  def setup_chassis_and_wheels
    pos = vec(100,270)
    @chassis = build_chassis(pos)
    @back_wheel = build_wheel(pos + vec(-50,30), 30)
#    @back_wheel = build_wheel(pos + vec(-40,30), 15)
    @front_wheel = build_wheel(pos + vec(40,30), 15)
    join_wheels_to_chassis

    @back_wheel_image = @media_loader.load_image("wheel-60.png")
    @front_wheel_image = @media_loader.load_image("wheel-30.png")
    @chassis_image = @media_loader.load_image("tractor-sideview-chassis-110.png")
  end

  def build_chassis(pos)
    verts = [
      vec(-18,-18),
      vec(-18,18),
      vec(18,18),
      vec(18,-18),
    ]
    mass = 5.0
    moment = CP::moment_for_poly(mass, verts, vec(0,0))
    chassis = CP::Body.new(mass, moment)
    chassis.p = pos

    shape = CP::Shape::Poly.new(chassis, verts, vec(0,0))
    shape.u = 0.5

    @space_holder.space.add_body(chassis)
    @space_holder.space.add_shape(shape)

    return chassis
  end

  def build_wheel(pos,wheel_radius)
    wheel_mass = 1.0
    v_zero = vec(0,0)
    wheel_moment = CP::moment_for_circle(wheel_mass, wheel_radius, 0.0, v_zero)
    wheel_body = CP::Body.new(wheel_mass, wheel_moment)
    wheel_body.p = pos

    shape = CP::Shape::Circle.new(wheel_body, wheel_radius, v_zero)
    shape.u = 1.5
    @space_holder.space.add_body(wheel_body)
    @space_holder.space.add_shape(shape)
    return wheel_body
  end

  def join_wheels_to_chassis
    back_joint = CP::Joint::Pin.new(@chassis, @back_wheel, vec(0,0), vec(0,0))
    front_joint = CP::Joint::Pin.new(@chassis, @front_wheel, vec(0,0), vec(0,0))
    @space_holder.space.add_joint(back_joint)
    @space_holder.space.add_joint(front_joint)
  end

  def draw_chassis_and_wheels
    @back_wheel_image.draw_rot(
                      @viewport.ox(@back_wheel.p.x),
                      @viewport.oy(@back_wheel.p.y),
                      1,
                      @back_wheel.a.radians_to_gosu)
    @front_wheel_image.draw_rot(
                      @viewport.ox(@front_wheel.p.x),
                      @viewport.oy(@front_wheel.p.y),
                      1,
                      @front_wheel.a.radians_to_gosu)
    @chassis_image.draw_rot(
                    @viewport.ox(@chassis.p.x),
                    @viewport.oy(@chassis.p.y),
                    1,
                    @chassis.a.radians_to_gosu - 90) # No sure why I need to rotate my chassis....
  end


end
