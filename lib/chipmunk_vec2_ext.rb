require 'chipmunk'

class CP::Vec2
  def freeze
    def self.x=(val)
      raise TypeError, "can't modify frozen Vec2"
    end
    def self.y=(val)
      raise TypeError, "can't modify frozen Vec2"
    end
    def normalize!
      raise TypeError, "can't modify frozen Vec2"
    end
    self
  end

  def ==(other)
    if other.class == CP::Vec2
      self.near?(other, 0.001)
    else
      false
    end
  end

  def dup
    self.class.new(x,y)
  end
end
