class ShapeRegistry
  def initialize
    setup
  end

  def setup
    @objects = {}
  end

  def add(shape, object)
    @objects[shape.object_id] = object
  end

  def remove(shape)
    @objects.delete(shape.object_id)
  end

  def lookup(shape)
    @objects[shape.object_id]
  end

end
