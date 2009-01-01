class UpdateInfo
  attr_accessor :dt

  def initialize(mw)
    @main_window = mw
  end

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

end
