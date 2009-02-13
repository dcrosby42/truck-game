class ViewportController
  attr_accessor :follow_target

  constructor :simulation, :viewport do 
    @manual = true
    @follow = false
    @follow_target = nil

    @simulation.on :button_down do |id, info|
      char = info.button_id_to_char(id)
      case char
      when "["
        use_manual_control
      when "]"
        follow_the_target
      end
    end

    @simulation.on :update_frame do |info|
      if @manual
        if info.letter_down? 'p'
          @viewport.x += 10
        end
        if info.letter_down? 'o'
          @viewport.x -= 10
        end
        if info.letter_down? 'i'
          @viewport.y += 10
        end
        if info.letter_down? 'u'
          @viewport.y -= 10
        end
      elsif @follow and @trailer
        @trailer.update_frame(info)
        @viewport.center_on @trailer.location + vec2(0,-200)
      end
    end

    @simulation.on :draw_frame do |info|
      if @follow and @trailer
        @trailer.draw(info)
      end
    end
  end

  def use_manual_control
    @follow = false
    @manual = true
  end

  def follow_the_target
    if @follow_target
      @manual = false
      @follow = true
      @trailer = Trailer.new(:follow_target => @follow_target, :viewport => @viewport)
    end
  end

  require 'debug_drawing'
  class Trailer
    constructor :follow_target, :viewport
    attr_accessor :location
    def setup
      @location = ZeroVec2
      @max_dist = 400
    end

    def update_frame(info)
      full_v = @follow_target.location - @location
      dist = full_v.length
      move_v = full_v.normalize * [100,(dist*dist) * 0.001].min
      @location += move_v
    end

    def draw(info)
      DebugDrawing.draw_cross_at_vec2(info.window, @viewport.offset_point(@location))
    end

  end

end
