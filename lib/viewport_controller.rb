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
      elsif @follow and @follow_target
        pt = @follow_target.location + vec2(100,-200)
        dest_x = pt.x - (@viewport.width / 2.0)
        dest_y = pt.y - (@viewport.height / 2.0)
        
        @viewport.x = dest_x
        @viewport.y = dest_y 
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
    end
  end

end
