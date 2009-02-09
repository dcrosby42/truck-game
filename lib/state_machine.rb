require 'state'
module StateMachine

  def be(state_name)
    raise "StateMachine #{self.class.name} has no @states" unless @states
    if @state
      @state.exit
    end 
    @state_name = state_name
    @state = @states[@state_name]
    @state.enter
  end

  def sneak_into(state_name)
    @state_name = state_name
    @state = @states[@state_name]
  end

  def is?(state_name)
    state_name == @state_name
  end
  
  def update_space(info)
    @state.update_space(info) if @state
  end

  def update_frame(info)
    @state.update_frame(info) if @state
  end

  private
  
  def init_state(sym, state)
    @states ||= {}
    state.machine = self
    @states[sym] = state
  end
end
