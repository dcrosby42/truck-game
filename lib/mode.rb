require 'base_mode'

class Mode < BaseMode
  extend Publisher
  can_fire :start, :stop
  can_fire :update, :draw, :button_down, :button_up

  def start
    fire :start
  end

  def button_down(id,update_info)
    fire :button_down, id, update_info
  end

  def button_up(id,update_info)
    fire :button_up, id, update_info
  end

  def update(update_info)
    fire :update, update_info
  end

  def draw(update_info)
    fire :draw, update_info
  end

  def stop
    fire :stop
  end

end

