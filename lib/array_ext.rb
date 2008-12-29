require 'enumerator'

class Array
  def each_edge
    self.each_cons(2) do |a,b|
      yield a,b
    end
    yield self[-1],self[0]
  end
end
