require 'slider_machine'

class SlidersController
  constructor :simulation, :media_loader do
    load_sliders

    @simulation.on :draw_frame do |info|
      @slider1.draw info
    end

    @simulation.on :update_space do |info|
      @slider_machine1.update_space(info)
    end
  end


end
