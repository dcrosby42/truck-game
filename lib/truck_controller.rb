class TruckController
  include Gosu

  constructor :simulation, :truck_factory do

    @truck = @truck_factory.build_truck
    @truck_controls = @truck.truck_controls
    @truck.cold_drop vec2(600,300)

    @simulation.on :draw_frame do |info| 
      @truck.draw
    end

    @simulation.on :update_frame do |info|
      @truck_controls.clear
      if info.button_down?(Button::KbLeft)
        @truck_controls.drive_left = true
      elsif info.button_down?(Button::KbRight)
        @truck_controls.drive_right = true
      elsif info.button_down?(Button::KbDown)
        @truck_controls.brake = true
      elsif info.button_down?(Button::KbA)
        @truck_controls.open_bucket = true
      elsif info.button_down?(Button::KbD)
        @truck_controls.close_bucket = true
      end
    end
  end

end

