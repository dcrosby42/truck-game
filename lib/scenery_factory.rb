require 'scenery'
class SceneryFactory
  constructor :picture_factory

  def build(svg_layer)
    objects = svg_layer.images.map do |svg_image|
      @picture_factory.build(:svg_image => svg_image, :z_order => ZOrder::Scenery)
    end
    Scenery.new(objects)
  end
end
