require 'gosu'
require 'update_info'

class MainWindow < Gosu::Window

  def initialize
    super width,height, fullscreen
    @stub_mode = BaseMode.new
    @mode = @stub_mode
    @update_info = UpdateInfo.new(self)
  end

  def button_down(id)
    @mode.button_down(id, @update_info)
  end

  def button_up(id)
    @mode.button_up(id, @update_info)
  end

  def width; 1024; end
  def height; 768; end
  def fullscreen; true; end

  def update
    @mode.update(@update_info)
  end

  def draw
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
