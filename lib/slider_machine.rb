require 'state_machine'
class SliderMachine 
  include StateMachine
  constructor :slider, :start_sound, :roll_sound, :lock_sound

  def setup
    init_state :locked_open, LockedOpen.new(:slider => @slider, :lock_sound => @lock_sound)
    init_state :sliding_open, SlidingOpen.new(:slider => @slider, :start_sound => @start_sound, :roll_sound => @roll_sound)
    init_state :locked_closed, LockedClosed.new(:slider => @slider, :lock_sound => @lock_sound)
    init_state :sliding_closed, SlidingClosed.new(:slider => @slider, :start_sound => @start_sound, :roll_sound => @roll_sound)
    init_state :nothing, State.nothing

    if @slider.locked_open?
      sneak_into :locked_open
    elsif @slider.locked_closed?
      sneak_into :locked_closed
    else
      sneak_into :nothing
    end
  end

  def open_hatch
    be :sliding_open
  end

  def close_hatch
    be :sliding_closed
  end

  private

  class SlidingOpen < State
    constructor :slider, :start_sound,:roll_sound

    def enter
      @start_sound.play
      @roll_sound.play
    end

    def update_space(info)
      if @slider.near_open?
        machine.be :locked_open
      else
        @slider.open(info.dt)
      end
    end
  end

  class LockedOpen < State
    constructor :slider, :lock_sound
    def enter
      @lock_sound.play
      @slider.lock_open
    end
    def exit
      @slider.unlock_open
    end
  end

  class SlidingClosed < State
    constructor :slider, :start_sound,:roll_sound

    def enter
      @start_sound.play
      @roll_sound.play
    end

    def update_space(info)
      if @slider.near_closed?
        machine.be :locked_closed
      else
        @slider.close(info.dt)
      end
    end
  end

  class LockedClosed < State
    constructor :slider, :lock_sound
    def enter
      @lock_sound.play
      @slider.lock_closed
    end
    def exit
      @slider.unlock_closed
    end
  end

  class Nothing < State
  end

end
