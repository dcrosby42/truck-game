require 'physical_circle'
require 'physical_poly'

class PhysicalFactory
  constructor :space_holder

  def build_circle(opts)
    PhysicalCircle.new(opts.merge(:space => @space_holder.space))
  end

  def build_poly(opts)
    PhysicalPoly.new(opts.merge(:space => @space_holder.space))
  end

end

