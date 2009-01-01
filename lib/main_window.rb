require 'gosu'
require 'update_info'

class MainWindow < Gosu::Window
  FRAMERATE = 60.0 # gosu default
  TICK = 1.0 / FRAMERATE # amount of time accounted for by a single Gosu update

  class Instantaneous
    def inspect
      "<This update is instantaneous and does not cover time>"
    end
    alias :to_s :inspect
  end

  def initialize
    super width,height, fullscreen
    @stub_mode = BaseMode.new
    @mode = @stub_mode
    @update_info = UpdateInfo.new(self)

    @no_time = Instantaneous.new
    @update_info.dt = @no_time
  end

  def button_down(id)
    @update_info.dt = @no_time
    @mode.button_down(id, @update_info)
  end

  def button_up(id)
    @update_info.dt = @no_time
    @mode.button_up(id, @update_info)
  end

  def width; 1024; end
  def height; 768; end
  def fullscreen; false; end

  def update
    @update_info.dt = TICK
    @mode.update(@update_info)
  end

  def draw
    @update_info.dt = TICK
    @mode.draw(@update_info)
  end

  def mode=(mode)
    unless mode.nil?
      @mode = mode 
    else
      mode = @stub_mode
    end
  end

end
