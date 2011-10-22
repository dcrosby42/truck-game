require 'forwardable'

class ImagePoly
  constructor :physical_poly, :image, :z_order

  extend Forwardable
  def_delegators :@physical_poly, :body, :shape, :mass, :world_vertices, :location, :angle_radians, :move_to, :move_by, :translate, :cold_drop, :remove_from_space

  def draw(info)
    if @image
      loc = info.view_point(location)
      @image.draw_rot(loc.x, loc.y, @z_order, angle_radians.radians_to_degrees)
    end
#    if @draw_polygon
#      draw_poly info
#    end
  end

end
