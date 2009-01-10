class Rectangle
  attr_reader :x, :y, :width, :height, :left, :right, :top, :bottom, :center

  def initialize(x,y,width,height)
    @x,@y,@width,@height = x,y,width,height
    calc_edges_and_center
  end

  def self.from_top_left_bottom_right(t,l,b,r)
    new(l,t, r-l, b-t)
  end

  def translate(vec)
    @x += vec.x
    @y += vec.y
    calc_edges_and_center
    self
  end

  def to_polygon
    if @polygon.nil?
      @polygon = Polygon.new([
        vec2( @left,  @top    ),
        vec2( @left,  @bottom ),
        vec2( @right, @bottom ),
        vec2( @right, @top    ),
      ])
      @polygon
    end
    @polygon.dup
  end

  def dup
    self.class.new(@x,@y,@width,@height)
  end

  def bounds
    self
  end

  private
  def calc_edges_and_center
    @left = @x
    @top = @y
    @right = @left + @width
    @bottom = @top + @height
    @center = vec2(@left + @width/2.0, @top + @height/2.0).freeze
    @polygon = nil
  end
end
