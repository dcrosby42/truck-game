require 'rectangle'
require 'polygon'

class Circle
  attr_reader :center, :radius, :bounds

  def initialize(center, radius)
    @center = center.dup.freeze
    @radius = radius
    calc_bounds
  end

  def translate(vec)
    @center += vec
    calc_bounds
    self
  end
  
  def to_polygon(segments=10)
    if @polygon.nil? or @polygon_segment_count != segments
      @polygon_segment_count = 10
      two_pi = 2 * Math::PI
      step_size = two_pi / segments
      verts = []
      0.step(two_pi - step_size, step_size) do |theta| 
        verts <<  @center + vec2(@radius * Math.cos(theta), @radius * Math.sin(theta))
      end
      @polygon = Polygon.new(verts)
      @polygon.freeze
    end
    @polygon
  end

  def dup
    self.class.new(@center, @radius)
  end

  def bounds
    @bounds
  end

  private

  def calc_bounds
    cx,cy = @center.x, @center.y
    @bounds = Rectangle.from_top_left_bottom_right(
      @center.y - @radius,
      @center.x - @radius,
      @center.y + @radius,
      @center.x + @radius
    )
    @bounds.freeze
    @polygon = nil
    @polygon_segment_count = 0
  end
end
