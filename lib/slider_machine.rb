class SliderMachine
  constructor :slider, :move_sound, :lock_sound

  def setup
    init_state :locked_open, LockedOpen.new(:slider => @slider, :lock_sound => @lock_sound)
    init_state :sliding_open, SlidingOpen.new(:slider => @slider, :move_sound => @move_sound)
    init_state :locked_closed, LockedClosed.new(:slider => @slider, :lock_sound => @lock_sound)
    init_state :sliding_closed, SlidingClosed.new(:slider => @slider, :move_sound => @move_sound)
    init_state :nothing, Nothing.new

    be :nothing
  end

  def open_hatch
    be :sliding_open
  end

  def close_hatch
    be :sliding_closed
  end

  def update_space(info)
    @state.update_space(info) if @state
  end

  def be(state_name)
#    puts "be #{state_name}"
    if @state
      @state.halt
    end 
    @state_name = state_name
    @state = @states[@state_name]
    @state.begin
  end

  def is?(state_name)
    state_name == @state_name
  end

  private

  def init_state(sym, state)
    @states ||= {}
    state.machine = self
    @states[sym] = state
  end

  class State
    attr_accessor :machine
    def begin
    end

    def halt
    end

    def update_space(info)
    end
  end

  class SlidingOpen < State
    constructor :slider, :move_sound

    def begin
      @move_sound.play
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
    def begin
      @lock_sound.play
      @slider.lock_open
    end
    def halt
      @slider.unlock_open
    end
  end

  class SlidingClosed < State
    constructor :slider, :move_sound

    def begin
      @move_sound.play
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
    def begin
      @lock_sound.play
      @slider.lock_closed
    end
    def halt
      @slider.unlock_closed
    end
  end

  class Nothing < State
  end

end
