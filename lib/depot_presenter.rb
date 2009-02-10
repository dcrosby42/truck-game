require 'state_machine'

class DepotPresenter
  constructor :slider_machine, :depot_switch, :depot_bucket, :depot_sign

  def setup
    @depot_switch.when :activated do
      if @slider_machine.is? :locked_closed
        @slider_machine.open_hatch
      else
        @slider_machine.close_hatch
      end
    end
    @depot_bucket.when :fruit_count_changed do |num|
      @depot_sign.set_fruit_count(num)
    end
  end

  class DepotSwitch
    extend Publisher
    include StateMachine
    constructor :switch_zone, :vehicle
    can_fire :activated
    public :fire

    def setup
      init_state :empty, Empty.new
      init_state :occupied, Occupied.new
      be :empty
    end

    def contains_vehicle?
      @switch_zone.contains?(@vehicle)
    end

    class Empty < State
      def update_frame(info)
        if machine.contains_vehicle?
          machine.be :occupied
        end
      end
    end

    class Occupied < State
      def initialize
        @trigger = ButtonDownTrigger.new(Gosu::Button::KbSpace) do
          machine.fire :activated
        end
      end

      def enter
        # Show key indicator
      end

      def update_frame(info)
        @trigger.update(info)
        unless machine.contains_vehicle?
          machine.be :empty
        end
      end
    end
  end

end

class ButtonDownTrigger
  def initialize(key_id,&block)
    @button_id = key_id
    @button_down = false
    @down_proc = block if block_given?
  end

  def update(info)
    if @button_down and !info.button_down?(@button_id)
      @button_down = false
    elsif !@button_down and info.button_down?(@button_id)
      @button_down = true
      @down_proc.call
    end
  end
end
