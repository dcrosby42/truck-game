class Tractor
  attr_accessor :x, :y, :r
  attr_accessor :current_engine_sample, :power, :reverse_power, :turn_sharpness, :drag_percent, :bg_music

  constructor :media_loader, :screen_info do
    load_graphics_and_sounds

    # Config
    @drag_percent = 0.2  # proportional to speed "friction" 
    @power = 0.7         # velocity increase per update
    @reverse_power = 0.45# negative velocity boost per update 
    @turn_sharpness = 1  # adjust the "degrees per distance" for turning
    @r = 30

    # Init
    @x = @y = @angle = @vel_mag = 0.0
    @accel_flag = @reverse_flag = false

    update_velocity_vector
  end

  def place_in_screen_center
    @x, @y = @screen_info.screen_width / 2, @screen_info.screen_height / 2
  end

  def turn_left
    @angle -= angle_delta
    @accel_flag = true # can be overridden by @reverse_flag
  end

  def turn_right
    @angle += angle_delta
    @accel_flag = true # can be overridden by @reverse_flag
  end

  def accelerate
    @accel_flag = true
  end

  def back_up
    @reverse_flag = true
  end

  def move
    perform_acceleration

    update_velocity_vector

    reposition

    play_engine_sound

    drag_down_velocity

    play_bg_music
  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::Tractor, @angle)
  end

  def stop
    @bg_music.stop if @bg_music
    @current_engine_sample.stop if @current_engine_sample
  end

  def debug_cycle_image
    if @image.object_id == @image1.object_id
      @image = @image2
    else
      @image = @image1
    end
  end

  private

  def perform_acceleration
    if @reverse_flag
      @vel_mag -= @reverse_power if @reverse_flag
    elsif @accel_flag
      @vel_mag += @power if @accel_flag
    end
    @accel_flag = false
    @reverse_flag = false
  end

  def update_velocity_vector
    @vel_x = Gosu::offset_x(@angle, @vel_mag)
    @vel_y = Gosu::offset_y(@angle, @vel_mag)
  end

  def reposition
    @x += @vel_x
    @y += @vel_y
    @x %= @screen_info.screen_width
    @y %= @screen_info.screen_height
  end

  def drag_down_velocity
    @vel_mag *= (1.0 - @drag_percent)
  end

  def angle_delta
    # Change in angle per "turn" event is proportional to ground speed.
    # (No change if not moving.)
    # NOTE: this only works out currently because you get to top speed quickly,
    # and any attempt to turn automatically triggers acceleration.
    # But, eg, if you programmatically "pulse" a left turn from script/console at 100 ms intervals,
    # the tractor does not accelerate very much and you'll see a much wider turn radius.
    # In short, this technique doesn't work, other than by coincidence
    @turn_sharpness * @vel_mag 
  end

  def play_engine_sound
    # Clear the current sample instance if it's done:
    if @current_engine_sample and !@current_engine_sample.playing?
        @current_engine_sample = nil
    end

    # Volume is 0.2 at idle, approaching 1.0 at full speed.
    # (Assumption: full speed is 4.0, hence the 0.25 factor)
    vol = 0.2 + (0.25 * @vel_mag.abs * 0.8)
    # Playback speed is 1.0 at idle and Volume is 0.2 at idle, approaching 1.0 at full speed.
    # (Assumption: full speed is 4.0, hence the 0.25 factor)
    speed = 1.0 + (0.25 * @vel_mag.abs)

    if @current_engine_sample
      # Adjust currently playing sample instance
      @current_engine_sample.volume = vol
      @current_engine_sample.speed = speed
    else
      # Start a new sample instance
      @current_engine_sample = @engine_sound.play(vol, speed)
    end
  end

  def play_bg_music
    @bg_music.play unless @bg_music.playing?
  end

  def load_graphics_and_sounds
    # Tractor img
    @image1 = @media_loader.load_image("tractor-overhead-50.png")
    @image2 = @media_loader.load_image("tractor-overhead-shadowed.png")
    @image = @image1

    # Engine sound
    @idle = @media_loader.load_sample("tractor-idle-long.wav")
    @engine_sound = @idle

#    music_file = "M6V-PONY.XM"
#    music_file = "bladerun.mod"
    music_file = "chariots.s3m"
    @bg_music = @media_loader.load_song(music_file)
    @bg_music.volume = 1.0
  end

end
