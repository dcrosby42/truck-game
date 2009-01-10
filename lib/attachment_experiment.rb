class AttachmentExperiment
  constructor :workshop_svg_holder, :space_holder, :simulation do
    build_bodies
    @simulation.on :draw_frame do |info|
      @sliding_door.draw info
    end

    @simulation.on :update_space do |info|
      if info.button_down?(Gosu::Button::KbO)
        @sliding_door.body.apply_impulse vec2(-400,0), vec2(0,0)
      end
      if info.button_down?(Gosu::Button::KbP)
        @sliding_door.body.apply_impulse vec2(400,0), vec2(0,0)
      end
    end
  end

  def build_bodies
#    g = @workshop_svg_holder.get_layer("proto").group("game:handle" => "two_boxes")
#    top_svg_rect = g.rect("game:handle" => "top_box")
#    top_svg_rect.translate g.translation
#    bottom_svg_rect = g.rect("game:handle" => "bottom_box")
#    bottom_svg_rect.translate g.translation
#
#    orig_top_center = top_svg_rect.bounds.center_point
#    orig_bottom_center = bottom_svg_rect.bounds.center_point
#    offset_vec = orig_bottom_center - orig_top_center

    # Build poly bodies
#    @top_box = build_box(top_svg_rect)
#    @bottom_box = build_box(bottom_svg_rect)

    top = -10
    left = -100
    bottom = 10
    right = 100
    verts = [
      vec2(left,top),
      vec2(left,bottom),
      vec2(right,bottom),
      vec2(right,top),
    ]
    @sliding_door = new_poly_body(:verts => verts, :group => :terrain)

    top = -10
    left = -110
    bottom = 0
    right = -100
    verts = [
      vec2(left,top),
      vec2(left,bottom),
      vec2(right,bottom),
      vec2(right,top),
    ]
    moment_of_inertia,mass = Float::Infinity,Float::Infinity
    @foundation_body = CP::Body.new(mass,moment_of_inertia)
    @foundation_shape = CP::Shape::Poly.new(@foundation_body, verts, ZeroVec2)
    @foundation_shape.group = :terrain
    @space_holder.space.add_shape(@foundation_shape)

    @joint_a = CP::Joint::Groove.new(
      @foundation_body,          @sliding_door.body,
      vec2(-300,0),vec2(-100,0), vec2(-100,0)
    )
    @space_holder.space.add_joint(@joint_a)

    @joint_b = CP::Joint::Groove.new(
      @foundation_body,         @sliding_door.body,
      vec2(-100,0),vec2(100,0), vec2(100,0)
    )
    @space_holder.space.add_joint(@joint_b)

#    @joint_b = CP::Joint::Slide.new(
#      @top_box.body,@bottom_box.body,
#      vec2(80,20), vec2(80,-10),
#      0,20
#    )
#    @space_holder.space.add_joint(@joint_b)

    # Move them back into play
#    move = orig_top_center
    move = vec2(8240,355)
    @sliding_door.body.p += move
    @foundation_body.p += move
  end

#  def build_box(rect)
#    bounds = rect.bounds.dup
#    bounds.recenter_on_zero
#    verts = bounds.vertices
#    new_poly_body(:verts => verts)
#  end

  def new_poly_body(opts)
    data = {
      :space => @space_holder.space,
      :draw_polygon => true,
      :mass => 50,
      :group => :slider_assembly
    }.merge(opts)
    PolyBody.new(data)
  end
end
