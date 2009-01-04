class CratesController
  constructor :simulation, :workshop_svg_holder, :media_loader, :rain_controller, :crate_factory do
    load_crates
    
    @simulation.on :draw_frame do |info|
      draw_crates info
    end

    @simulation.on :update_space do |info|
#      if info.button_down?(Button:KbA)
#        drop_block_from @crate_index["apple"]
#      elsif info.button_down?(Button:KbB)
#        drop_block_from @crate_index["bannana"]
#      elsif info.button_down?(Button:KbS)
#        drop_block_from @crate_index["strawberry"]
#      end
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

  def drop_block_from(crate)
#    @rain_controller.add_block crate.center_to_world
  end

#    def translated_x_y(obj)
#      t = @g.translation
#      [ 
#        obj.x + t.x,
#        obj.y + t.y,
#      ]
#    end
#  end
  
end
