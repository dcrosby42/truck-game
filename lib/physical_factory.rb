require 'physical_circle'
require 'physical_poly'
require 'image_poly'

class PhysicalFactory
  constructor :space_holder

  def build_circle(opts)
    PhysicalCircle.new(opts.merge(:space => @space_holder.space))
  end

  def build_poly(opts)
    PhysicalPoly.new(opts.merge(:space => @space_holder.space))
  end

  def build_normalized_poly_in_place(opts)
    polygon = opts[:polygon]
    loc = polygon.center
    polygon.translate(-loc)
    opts[:location] ||= loc
    build_poly(opts)
  end

  def build_image_poly(opts)
    image = opts.delete(:image)
    z = opts.delete(:z_order) || 0
    poly = build_poly(opts)
    ImagePoly.new(:physical_poly => poly, :image => image, :z_order => z)
  end

end
