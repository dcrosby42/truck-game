class State
  attr_accessor :machine

  def enter
  end

  def exit
  end

  def update_space(info)
  end

  def update_frame(info)
  end

  def self.nothing
    Nothing.new
  end

  class Nothing < State
  end
end
