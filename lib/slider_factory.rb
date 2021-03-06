require 'slider'

class SliderFactory
  constructor :physical_factory, :media_loader, :joint_factory

  def build_left_slider(slider_g)
    svg_image = slider_g.image
    image_name = svg_image.image_name
    rect = svg_image.bounds
    rect.translate(slider_g.translation)
    polygon = rect.to_polygon
    
    # Recenter on 0,0
    home = polygon.center
    polygon.translate(-home)

    # Slider door
    image = @media_loader.load_image(image_name, true)
    slider_door = @physical_factory.build_image_poly(
      :polygon => polygon,
      :image => image,
      :mass => 50,
      :group => :terrain,
      :z_order => ZOrder::Sliders
    )

    # Anchor
    anchor_rect = Rectangle.new(-5,-5,10,10)
    anchor =  @physical_factory.build_poly(
      :polygon => anchor_rect.to_polygon,
      :as_anchor => true,
      :group => :terrain
    )

    # Groove joints
    bounds = polygon.bounds
    left_pt = vec2(bounds.left,0)
    right_pt = vec2(bounds.right,0)
    width = bounds.width

    groove_a = @joint_factory.new_groove(
      :groove_on => anchor.body,
      :attach_to => slider_door.body,
      :groove_start => vec2(left_pt.x-width,0),
      :groove_stop => left_pt,
      :groove_attach => left_pt,
      :auto_add => true
    )
    groove_b = @joint_factory.new_groove(
      :groove_on => anchor.body,
      :attach_to => slider_door.body,
      :groove_start => vec2(right_pt.x-width,0),
      :groove_stop => right_pt,
      :groove_attach => right_pt,
      :auto_add => true
    )

    closed_latch = @joint_factory.new_fastener(
      :body_a => slider_door.body,
      :body_b => anchor.body,
      :fasten_at_world => right_pt
    )

    slider_door.translate(vec2(-200,0))
    open_latch = @joint_factory.new_fastener(
      :body_a => slider_door.body,
      :body_b => anchor.body,
      :fasten_at_world => left_pt
    )
    slider_door.translate(vec2(200,0))
    
    slider = Slider.new(
      :door => slider_door,
      :anchor => anchor,
      :open_latch => open_latch,
      :closed_latch => closed_latch,
      :grooves => [ groove_a, groove_b ]
    )
    slider.lock_closed

    slider.translate(home)
    slider
  end
end
