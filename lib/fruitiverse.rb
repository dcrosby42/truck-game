class Fruitiverse
  attr_reader :fruits
  def initialize
    @fruits = []
  end

  def add(fruit)
    @fruits << fruit
  end

  def remove(fruit)
    @fruits.delete(fruit)
  end

  def cap_size(size)
    while @fruits.size > 400
      @fruits.shift.remove_from_space
    end
  end

  def draw(info)
    @fruits.each do |fruit|
      fruit.draw info
    end
  end
end
