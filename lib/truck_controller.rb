class TruckController
  include Gosu

  constructor :simulation, :truck_factory do

    @truck = @truck_factory.build_truck
    @truck_controls = @truck.truck_controls
    @truck.cold_drop vec2(600,300)

    @simulation.on :update_frame do |info|
      @truck_controls.clear
      if info.button_down?(Button::KbLeft)
        @truck_controls.drive_left = true
      end
      if info.button_down?(Button::KbRight)
        @truck_controls.drive_right = true
      end
      if info.button_down?(Button::KbDown)
        @truck_controls.brake = true
      end
      if info.button_down?(Button::KbA)
        @truck_controls.open_bucket = true
      end
      if info.button_down?(Button::KbD)
        @truck_controls.close_bucket = true
      end
    end

    @simulation.on :button_down do |id,info|
      case id
      when Button::KbTab
        @truck.cold_drop @truck.location + vec2(0,-100)
      end
    end

  end

end

