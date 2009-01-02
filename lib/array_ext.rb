require 'enumerator'

class Array
  def each_segment(&block)
    self.each_cons(2) do |a,b|
      block.call a,b
    end
  end

  def each_edge(&block)
    each_segment(&block)
    block.call self[-1],self[0]
  end
end
