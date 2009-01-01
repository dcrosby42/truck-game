class TruckController
  include Gosu

  constructor :mode, :truck_factory do

    @truck = @truck_factory.build_truck
    @truck.cold_drop vec2(600,300)

    @mode.on :draw do |info| 
      @truck.draw
    end

    @mode.on :update do |info|
      if info.button_down?(Button::KbLeft)
        @truck.drive_left
      elsif info.button_down?(Button::KbRight)
        @truck.drive_right
      elsif info.button_down?(Button::KbDown)
        @truck.brake
      elsif info.button_down?(Button::KbA)
        @truck.open_bucket
      elsif info.button_down?(Button::KbD)
        @truck.close_bucket
      end
    end
  end

end

