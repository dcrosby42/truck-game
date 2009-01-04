require 'poly_body'
class Fruit < PolyBody
  def initialize(opts)
    opts[:collision_type] ||= :fruit
    super opts
  end
end
