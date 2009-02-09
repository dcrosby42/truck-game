class DepotCollisionManager
  constructor :space_holder, :fruitiverse

  def setup
    @depots = {}
  end

  def manage(depot)
    init_collision_detect
    @depots[depot.bucket_shape] = depot
  end

  private
  def find_fruit(fruit_shape)
    @fruitiverse.find_by_shape(fruit_shape)
  end

  def init_collision_detect
    if !@detecting
      @space_holder.space.add_collision_func(:depot_bucket, :fruit) do |bucket_shape, fruit_shape|
        puts "(:depot_bucket,:fruit)"
        depot = @depots[bucket_shape]
        depot.handle_fruit(find_fruit(fruit_shape)) if depot
      end
      @detecting = true
    end
  end
end
