require 'slider_machine'

class SlidersController
  constructor :simulation, :slider_source, :media_loader do
    load_sliders

    @simulation.on :draw_frame do |info|
      @slider1.draw info
    end

    @simulation.on :button_down do |id,info|
      if id == Gosu::Button::Kb0
        @slider_machine1.close_hatch
      end
      if id == Gosu::Button::Kb9
        @slider_machine1.open_hatch
      end
    end

    @simulation.on :update_space do |info|
      @slider_machine1.update_space(info)
    end
  end

  def load_sliders
    @slider1 = @slider_source.get("slider1")

    move_sound = @media_loader.load_sample("slider_servo.wav")
    lock_sound = @media_loader.load_sample("clunk.wav")
    @slider_machine1 = SliderMachine.new(:slider => @slider1, :move_sound => move_sound, :lock_sound => lock_sound)
  end

end
