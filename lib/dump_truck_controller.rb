class DumpTruckController
  include Gosu

  constructor :simulation, :dump_truck do
    @dump_truck_controls = @dump_truck.dump_truck_controls

    @simulation.on :update_frame do |info|
      @dump_truck_controls.clear
      if info.button_down?(Button::KbLeft)
        @dump_truck_controls.drive_left = true
      end
      if info.button_down?(Button::KbV)
        @dump_truck_controls.boost = true
      end
      if info.button_down?(Button::KbRight)
        @dump_truck_controls.drive_right = true
      end
      if info.button_down?(Button::KbDown)
        @dump_truck_controls.brake = true
      end
      if info.button_down?(Button::KbZ)
        @dump_truck_controls.open_bucket = true
      end
      if info.button_down?(Button::KbX)
        @dump_truck_controls.close_bucket = true
      end
      if info.button_down?(Button::KbC)
        @dump_truck_controls.lock_bucket = true
      end
      if info.button_down?(Button::KbSpace)
        @dump_truck_controls.honk = true
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

