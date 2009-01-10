class SliderSource
  constructor :workshop_svg_holder, :slider_factory

  def get(name)
    g = sliders_layer.group("game:handle" => "slider1")
    svg_image = g.image

    rect = svg_image.bounds
    rect.translate(g.translation)

    polygon = rect.to_polygon
    @slider_factory.build_slider(
      :polygon => polygon, 
      :image_name => svg_image.image_name,
      :anchor_position => :left
    )
  end

  def sliders_layer
    @sliders_layer ||= @workshop_svg_holder.get_layer("sliders")
  end
end
