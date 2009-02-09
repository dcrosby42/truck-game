require 'forwardable'

class Fruit
  constructor :kind, :image_poly, :accessors => true

  extend Forwardable
  def_delegators :@image_poly, :move_to, :draw, :body, :remove_from_space, :location, :shape

  def change_collision_type(new_type)
    @image_poly.shape.collision_type = new_type
  end
end
