
class Corn
  attr_accessor :x, :y, :r
  
  def initialize(media_loader)
    @image = media_loader.load_image("corn-small.png")

    @scale = 0.75 + rand * 0.25
    @r = 20 * @scale
    @angle = -45.0 + (rand * 90.0)
  end
  
  def draw
    @image.draw_rot(@x, @y, ZOrder::Collectibles, @angle, 0.5,0.5, @scale, @scale)
  end
end

