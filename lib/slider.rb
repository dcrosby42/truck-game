class Slider
  constructor :door, :anchor, :grooves, :closed_latch, :open_latch do
#    @locked_open = false
    @locked_closed = false
  end

  def draw(info)
    @door.draw info
  end

  def translate(vec)
    @door.translate(vec)
    @anchor.translate(vec)
  end

  def open(dt)
    unlock_closed
    @door.body.apply_impulse vec2(-100,0), vec2(0,0)
  end

  def close(dt)
    @door.body.apply_impulse vec2(100,0), vec2(0,0)
  end

  def lock_open
#    unlock_closed
    @open_latch.add_to_space
    @locked_open = true
  end
#
  def unlock_open
    @open_latch.remove_from_space
    @locked_open = false
  end

  def lock_closed
#    unlock_open
    @closed_latch.add_to_space
    @locked_closed = true
  end

  def unlock_closed
    @closed_latch.remove_from_space
    @locked_closed = false
  end

  def near_open?
    (@door.location - @anchor.location).x < -199
  end

  def near_closed?
    (@door.location - @anchor.location).x > -1
  end
end

