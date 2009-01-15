class Scenery
  def initialize(drawables)
    @drawables = drawables
  end

  def draw(info)
    @drawables.each do |d|
      d.draw info
    end
  end
end
