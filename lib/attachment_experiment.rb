class AttachmentExperiment
  constructor :workshop_svg_holder, :space_holder, :simulation do
    build_bodies
    @simulation.on :draw_frame do |info|
      @top_box.draw info
      @bottom_box.draw info
    end

    @simulation.on :update_space do |info|
      if info.button_down?(Gosu::Button::KbO)
        @top_box.body.apply_impulse vec2(200,-600), vec2(-10,0)
      end
      if info.button_down?(Gosu::Button::KbP)
        @bottom_box.body.apply_impulse vec2(-200,-600), vec2(10,0)
      end
#      if info.letter_down?("]")
#        @top_box.body.apply_impulse vec2(200,200)
#      end
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

    top = -15
    bottom = 15
    left = -100
    right = 100
    verts = [
      vec2(left,top),
      vec2(left,bottom),
      vec2(right,bottom),
      vec2(right,top),
    ]
    @top_box = new_poly_body(verts)
    @bottom_box = new_poly_body(verts)

    # Layout and attach
    @top_box.move_to(ZeroVec2)
    @bottom_box.move_to(vec2(0,30))
    
#    @joint_a = CP::Joint::Pin.new(
#      @top_box.body,@bottom_box.body,
#      vec2(-80,15), vec2(-80,-15)
#    )
    @joint_a = CP::Joint::Pivot.new(
      @top_box.body,@bottom_box.body,
      vec2(-80,15)
    )
    @space_holder.space.add_joint(@joint_a)

    @joint_b = CP::Joint::Pivot.new(
      @top_box.body,@bottom_box.body, 
      vec2(100,-5)
      vec2(80,15)
    )
#    @joint_b = CP::Joint::Slide.new(
#      @top_box.body,@bottom_box.body,
#      vec2(80,20), vec2(80,-10),
#      0,20
#    )
    @space_holder.space.add_joint(@joint_b)

    # Move them back into play
#    move = orig_top_center
    move = vec2(800,250)
    @top_box.move_by move
    @bottom_box.move_by move
  end

  def build_box(rect)
    bounds =  rect.bounds.dup
    bounds.recenter_on_zero
    verts = bounds.vertices
    new_poly_body(verts)
  end

  def new_poly_body(verts)
    PolyBody.new(
      :space => @space_holder.space,
      :verts => verts,
      :draw_polygon => true,
      :mass => 50,
      :group => :two_boxes
    )
  end
end
