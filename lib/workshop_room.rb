require 'simple_barrier'

class WorkshopRoom
  constructor :mode, :screen_info, :main_window, :space_holder do
    build_floor

    @mode.on :draw do
      draw
    end

    @mode.on :button_down do |id,info|
      case id
      when Gosu::Button::KbEscape
        @mode.abort_level
      when Gosu::Button::KbF1
        @mode.complete_level
      end
    end

    substeps = 3
    dt = SpaceHolder::TICK / substeps
    @mode.on :update do |info|
      substeps.times do 
        @space_holder.step dt
      end
    end
  end

  def draw
    @drawables.each do |d|
      d.draw @main_window
    end
  end

  private

  def build_floor
    win_height = @screen_info.screen_height
    win_width = @screen_info.screen_width

    @drawables = []

    @floor = create_barrier(
      :location => vec2(50, win_height-50),
      :angle => 0,
      :length => win_width - (50*2),
      :space => @space_holder.space
    )
    @drawables << @floor

    @right_ramp = create_barrier(
      :location => vec2(win_width-50, win_height-50),
      :angle => -45,
      :length => 200,
      :space => @space_holder.space
    )
    @drawables << @right_ramp

    @left_ramp = create_barrier(
      :location => vec2(50, win_height-50),
      :angle => 180,
      :length => 200,
      :space => @space_holder.space
    )
    @drawables << @left_ramp
  end

  def create_barrier(opts)
    SimpleBarrier.new(opts)
  end
end
