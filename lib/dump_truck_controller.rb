class DumpTruckController
  include Gosu

  constructor :simulation, :dump_truck, :viewport_controller do
    @truck_controls = @dump_truck.dump_truck_controls

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
      if info.button_down?(Button::KbZ)
        @truck_controls.open_bucket = true
      end
      if info.button_down?(Button::KbX)
        @truck_controls.close_bucket = true
      end
      if info.button_down?(Button::KbC)
        @truck_controls.lock_bucket = true
      end
    end

    @simulation.on :button_down do |id,info|
      case id
      when Button::KbTab
        if info.button_down?(Button::KbRightShift)
          @dump_truck.cold_drop @dump_truck.location + vec2(100,-100)
        else
          @dump_truck.cold_drop @dump_truck.location + vec2(0,-100)
        end
      end
    end

  end

end

