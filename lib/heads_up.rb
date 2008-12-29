class HeadsUp
  attr_accessor :item_count

  constructor :mode, :media_loader, :screen_info, :item_counter do

    @mode.on :draw do |info|
      @item_counter.draw(@item_count.to_s)
      draw_notice info
    end

    @notice_font = @media_loader.load_default_font(50)
    @notice_color = 0xffffff00

    @score_sound = @media_loader.load_sample("score-one.wav")

    @item_count = 0
  end

  def count_up
    @item_count += 1
    @score_sound.play(0.5)
  end

  def show_notice(text,time=3.0, &block)
    @notice = text
    @notice_time = time.to_f
    @notice_follow_on = block
  end

  private

  def draw_notice(info)
    return unless @notice

    ms = info.milliseconds
    @notice_epoch ||= ms

    if (ms - @notice_epoch) < (1000*@notice_time)
      x = info.screen_width / 2
      y = 150
      @notice_font.draw_rel(@notice, 
                            x, y, ZOrder::GuiText, 
                            0.5, 0.5,
                            1.0, 1.0,
                            @notice_color)
      @notice_font.draw_rel(@notice, 
                            x + 2, y + 5, ZOrder::GuiText-1, 
                            0.5, 0.5,
                            1.0, 1.0,
                            0xcc000000)
    else
      @notice = nil
      @notice_time = nil
      @notice_epoch = nil
      @notice_follow_on.call if @notice_follow_on
      @notice_follow_on = nil
    end
  end

end
