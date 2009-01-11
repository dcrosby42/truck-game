#
# Event converter to present a combination of Gosu update and draw events with
# the Chipmunk physics space updates.
#
# Space updates happen several times per Gosu tick.  Objects participating in the
# physics simulation should update themselves at this rate, not at the frame rate.
#
# :update_frame is the Gosu update event, emitted just before the space updates 
# get propagated for this tick.  Useful for non-physical updates, or for setting input state on a machine before it gets its space updates.
# You should use info.dt in any time-sensitive calcs in case the Gosu framerate changes.
#
# :update_space is the more frequent Chipmunk update. Happens SUBSTEPS times per Gosu
# update.  All substep updates are provided with the current "info" object for the
# Gosu tick, so you can check button state etc. You should use info.dt in your 
# object updates, in case the space-updates-per-gosu-tick ratio is changed.
#
#
# :draw_frame is the normal draw event from Gosu.
#
class Simulation
  extend Publisher
  can_fire :update_frame, :draw_frame, :update_space, :button_down, :button_up, :starting, :started, :stopping, :stopped

  GRAVITY = 900
  DAMPING = 0.7 
  SUBSTEPS = 3 # how many space updates per main gosu tick
  DT = MainWindow::TICK / SUBSTEPS # time accounted for by a single space update

  constructor :mode, :space_holder do
    configure_space

    @mode.on :start do
      fire :starting
      fire :started
    end

    @mode.on :stop do
      fire :stopping
      fire :stopped
    end

    @mode.on :update do |info|
      fire :update_frame, info
      do_space_steps info
    end

    @mode.on :draw do |info|
      fire :draw_frame, info
    end

    @mode.on :button_down do |id, info|
      fire :button_down, id, info
    end

    @mode.on :button_up do |id, info|
      fire :button_up, id, info
    end

  end

  private
    
  def configure_space
    space = @space_holder.space
    space.iterations = 5
    space.damping = DAMPING
    space.gravity = vec2(0,GRAVITY)
  end

  # Fire a series of space updates.
  # "info.dt" will be temporarily set to the correct size
  # for these micro updates.
  def do_space_steps(info)
    old_dt = info.dt
    info.dt = DT
    SUBSTEPS.times do 
      fire :update_space, info
      @space_holder.step DT
    end
    info.dt = old_dt
  end
end
