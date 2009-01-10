class SliderSource
  constructor :workshop_svg_holder

  def get(name)
    slider = @sliders[name]
    if slider.nil? 
      g = sliders_layer.group("game:handle" => name)
      img = g.image

      bounds = img.bounds.dup
      loc = bounds.center_point
      bounds.recenter_on_zero
      bounds.vertices
    end
  end

  def sliders_layer
    @sliders_layer ||= @workshop_svg_holder.get_layer("sliders")
  end
end
