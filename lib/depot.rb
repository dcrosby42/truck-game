class Depot
  constructor :slider, :slider_machine, :depot_switch, :zone, :depot_bucket, :depot_sign

  def update_space(info)
    @slider_machine.update_space(info)
  end

  def update_frame(info)
    @depot_switch.update_frame(info)
    @depot_bucket.update_frame(info)
  end

  def draw(info)
#    @zone.draw(info)
    @slider.draw(info)
    @depot_bucket.draw(info)
    @depot_sign.draw(info)
  end

  def bucket_shape
    @depot_bucket.shape
  end

  def handle_fruit(fruit)
    fruit.change_collision_type(:depot_bucket)
    puts "FRUIT! It's #{fruit.kind}"
  end
end
