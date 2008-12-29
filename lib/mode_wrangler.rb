class ModeWrangler
  constructor :main_window do
    @modes = []
  end
  
  def push(mode)
    if @modes.last 
      @modes.last.stop   
    end

    @modes.push mode

    @main_window.mode = mode
    mode.mode_wrangler = self
    mode.start
  end

  def pop
    prev_mode = @modes.pop
    prev_mode.stop 

    mode = @modes.last

    if mode
      @main_window.mode = mode
      mode.mode_wrangler = self
      mode.start
    else
      @main_window.close
    end
  end

end
