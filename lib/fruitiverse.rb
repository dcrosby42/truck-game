class Fruitiverse
  constructor :shape_registry
  attr_reader :fruits

  def setup
    @fruits = []
  end

  def add(fruit)
    @shape_registry.add(fruit.shape, fruit)
    @fruits << fruit
  end

  def cap_size(size)
    while @fruits.size > size
      cleanup @fruits.shift
    end
  end

  def draw(info)
    @fruits.each do |fruit|
      fruit.draw info
    end
  end

  private
  def cleanup(fruit)
    fruit.remove_from_space
    @shape_registry.remove(fruit.shape)
  end
end
