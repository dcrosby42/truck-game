
class BaseMode
  def start; end
  def button_down(id,update_info); end
  def button_up(id,update_info); end
  def update(update_info); end
  def draw(update_info); end
  def stop; end

  def mode_wrangler=(mode_wrangler)
    @mode_wrangler = mode_wrangler
  end

  def push_mode(mode)
    @mode_wrangler.push(mode)
  end

  def pop_mode
    @mode_wrangler.pop
  end

end
  
