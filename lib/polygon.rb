require 'rectangle'

class Polygon
  attr_reader :vertices, :center, :bounds

  def initialize(vertices, opts={})
    @vertices = vertices.dup
    freeze_vertices
    calc_bounds_and_center
  end

  def translate(vec)
    @vertices = @vertices.map do |v|
      v + vec
    end
    freeze_vertices
    calc_bounds_and_center
    self
  end

  def to_polygon
    dup
  end

  def dup
    self.class.new(@vertices)
  end

  private
  def freeze_vertices
    @vertices.each { |v| v.freeze }
    @vertices.freeze
  end

  def calc_bounds_and_center
    min_x, min_y, max_x, max_y = 0,0,0,0
    @vertices.each do |v|
      min_x = v.x if v.x < min_x
      min_y = v.y if v.y < min_y
      max_x = v.x if v.x > max_x
      max_y = v.y if v.y > max_y
    end
    @bounds = Rectangle.new(min_x,min_y, (max_x-min_x), (max_y-min_y))
    @bounds.freeze

    @center = @vertices.inject(ZeroVec2) { |sum,pt| sum + pt } / @vertices.size
    @center.freeze
  end
end
