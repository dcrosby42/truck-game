class TractorController
  constructor :mode, :tractor do

    @mode.on :start do
      @tractor.place_in_screen_center
    end

    @mode.on :update do |info|
      next if @stopped     
      if info.button_down? Gosu::KbUp
        @tractor.accelerate
      end
      if info.button_down? Gosu::KbDown
        @tractor.back_up
      end
      if info.button_down? Gosu::KbLeft
        @tractor.turn_left
      end
      if info.button_down? Gosu::KbRight
        @tractor.turn_right
      end

      @tractor.move unless @stopped
    end

    @mode.on :draw do
      @tractor.draw unless @stopped
    end

    @mode.on :stop do
      @stopped = true
      @tractor.stop
    end

  end
end
