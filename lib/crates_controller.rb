class CratesController
  constructor :simulation, :workshop_svg_holder, :crate_factory, :fruit_factory do
    load_crates
    @fruits = []
    
    @simulation.on :button_down do |id,info|
      case id
      when Gosu::Button::KbTab
        clear_fruits
      end
    end

    @simulation.on :update_frame do |info|
      if info.button_down?(Gosu::Button::KbA)
        drop_fruit "apple"
      end
#      elsif info.button_down?(Button:KbB)
#        drop_block_from @crate_index["bannana"]
#      elsif info.button_down?(Button:KbS)
#        drop_block_from @crate_index["strawberry"]
#      end
    end

    @simulation.on :draw_frame do |info|
      draw_crates info
      draw_fruits info
    end

  end

  private

  def load_crates
    layer = @workshop_svg_holder.get_layer("crates")
    @crate_set = @crate_factory.build_crate_set(layer)
  end

  def draw_crates(info)
    @crate_set.each do |img|
      img.draw(info)
    end
  end

  def drop_fruit(name)
    crate = @crate_set[name]
    fruit = @fruit_factory.send("build_#{name}")
    fruit.move_to(crate.center_point + vec2(0,50))
    fruit.location.x += rand(20) - 10
    @fruits << fruit
  end

  def draw_fruits(info)
    @fruits.each do |fruit|
      fruit.draw info
    end
  end

  def clear_fruits
    while !@fruits.empty?
      f = @fruits.shift
      f.remove_from_space
    end
  end

end
