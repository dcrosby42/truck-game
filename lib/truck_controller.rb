class TruckController
  include Gosu

  constructor :simulation, :truck_factory, :viewport_controller, :workshop_zones_controller, :workshop_svg_holder do

    @truck = @truck_factory.build_truck
    @truck_controls = @truck.truck_controls
    @truck.cold_drop lookup_truck_start_position

    @viewport_controller.follow_target = @truck
    @viewport_controller.follow_the_target

    @workshop_zones_controller.watch(@truck)

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
          @truck.cold_drop @truck.location + vec2(100,-100)
        else
          @truck.cold_drop @truck.location + vec2(0,-100)
        end
      end
    end

  end

  def lookup_truck_start_position
    layer = @workshop_svg_holder.get_layer("positions")
    img = layer.image("game:handle" => "truck_start")
    img.bounds.center_point
  end

end

