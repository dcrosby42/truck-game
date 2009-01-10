class SlidersController
  constructor :slider_source, :simulation do
    load_sliders
  end

  def load_sliders

    layer = @workshop_svg_holder.get_layer("sliders")
    @slider1 = @slider_source.get("slider1")

  end
end
