class SliderSource
  constructor :svg_loader, :slider_factory

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
    @sliders_layer ||= @svg_loader.get_layer_from_file("terrain_proto.svg", "sliders")
  end
end
