class Hay
  attr_accessor :x, :y, :r

  def initialize(media_loader)
    @image = media_loader.load_image("hay-bail-small.png")
    @scale = 1.0
    @r = 30 * @scale
    @angle = 0.0
  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::Collectibles, @angle, 0.5,0.5, @scale, @scale)
  end

end
