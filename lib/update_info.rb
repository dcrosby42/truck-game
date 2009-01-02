class UpdateInfo
  constructor :main_window, :viewport

  attr_accessor :dt

  def window
    @main_window
  end

  def button_down?(id)
    @main_window.button_down?(id)
  end

  def letter_down?(str)
    id = GosuCharIdMap::Char[str] or return false
    button_down? id
  end

  def screen_width
    @main_window.width
  end

  def screen_height
    @main_window.height
  end
  
  def milliseconds
    Gosu::milliseconds
  end

  def view_x(x)
    @viewport.offset_x(x)
  end

  def view_y(y)
    @viewport.offset_y(y)
  end

  def view_point(pt)
    @viewport.offset_point(pt)
  end

end
