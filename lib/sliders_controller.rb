class SlidersController
  constructor :simulation, :slider_source do
    load_sliders

    @simulation.on :draw_frame do |info|
      @slider1.draw info
    end

    @simulation.on :update_space do |info|
      if info.button_down?(Gosu::Button::KbP)
        @slider1.lock_closed
      end
      if info.button_down?(Gosu::Button::KbO)
        @slider1.close
      end
      if info.button_down?(Gosu::Button::KbI)
        @slider1.open
      end
#      if info.button_down?(Gosu::Button::KbU)
#        @slider1.lock_open
#      end
    end
  end

  def load_sliders
    @slider1 = @slider_source.get("slider1")
  end
end
