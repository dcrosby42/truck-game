class CratesController
  constructor :simulation, :crate_set, :fruit_factory, :fruitiverse do
    
    @simulation.on :button_down do |id,info|
      case id
      when Gosu::Button::Kb1
        clear_fruits
      end
    end

    @simulation.on :update_frame do |info|
      if info.button_down?(Gosu::Button::KbA)
        drop_fruit info, "apple"
      end
      if info.button_down?(Gosu::Button::KbB)
        drop_fruit info, "banana"
      end
      if info.button_down?(Gosu::Button::KbS)
        drop_fruit info, "strawberry"
      end
      if info.button_down?(Gosu::Button::KbL)
        drop_fruit info, "lettuce"
      end
    end

    @simulation.on :draw_frame do |info|
      draw_crates info
      draw_fruits info
    end

  end

  private

  def draw_crates(info)
    @crate_set.each do |img|
      img.draw(info)
    end
  end

  def drop_fruit(info, name)
    crate = @crate_set[name]
    fruit = @fruit_factory.new_fruit(name)
    x = rand(20) - 10
    fruit.move_to(crate.center + vec2(x,50))
    if info.button_down?(Gosu::Button::KbRightShift)
      fruit.body.apply_impulse(vec2(0,-600),vec2(-15,-5))
    end
    @fruitiverse.add(fruit)
    @fruitiverse.cap_size(400)
  end

  def draw_fruits(info)
    @fruitiverse.draw(info)
  end

  def clear_fruits
    @fruitiverse.cap_size(0)
  end

end
