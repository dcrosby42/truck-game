class DumpTruckController
  include Gosu

  constructor :simulation, :dump_truck do
    @dump_truck_controls = @dump_truck.dump_truck_controls

    @simulation.on :update_frame do |info|
      @dump_truck_controls.clear
      if info.button_down?(Button::KbLeft) or info.button_down?(Button::GpLeft)
        @dump_truck_controls.drive_left = true
      end
      if info.button_down?(Button::KbV) or info.button_down?(Button::GpButton5)
        @dump_truck_controls.boost = true
      end
      if info.button_down?(Button::KbRight) or info.button_down?(Button::GpRight)
        @dump_truck_controls.drive_right = true
      end
      if info.button_down?(Button::KbDown) or info.button_down?(Button::GpButton4)
        @dump_truck_controls.brake = true
      end
      if info.button_down?(Button::KbZ) or info.button_down?(Button::GpButton0)
        @dump_truck_controls.open_bucket = true
      end
      if info.button_down?(Button::KbX) or info.button_down?(Button::GpButton1)
        @dump_truck_controls.close_bucket = true
      end
      if info.button_down?(Button::KbC) or info.button_down?(Button::GpButton2)
        @dump_truck_controls.lock_bucket = true
      end
      if info.button_down?(Button::KbSpace) or info.button_down?(Button::GpButton3)
        @dump_truck_controls.honk = true
      end
    end

    @simulation.on :button_down do |id,info|
      case id
      when Button::KbTab, Button::GpButton9
        if info.button_down?(Button::KbRightShift) or info.button_down?(Button::GpButton8)
          @dump_truck.cold_drop @dump_truck.location + vec2(100,-100)
        else
          @dump_truck.cold_drop @dump_truck.location + vec2(0,-100)
        end
      end
    end

  end

end

