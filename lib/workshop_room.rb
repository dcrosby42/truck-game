
class WorkshopRoom
  constructor :mode, :simulation, :terrain_factory, :background_factory, :dump_truck_factory, :viewport_controller, :workshop_zones_controller, :svg_loader, :crate_factory do

    @draw_targets = []
    @update_space_targets = []
    @update_frame_targets = []

    @terrain = @terrain_factory.load_from_file("terrain_proto.svg")
    add_to_simulation @terrain

    @background = @background_factory.build(:image_name => "repeating_sky.png")
    add_to_simulation @background

    @dump_truck = @dump_truck_factory.build_dump_truck
    add_to_simulation @dump_truck

    @dump_truck_controller = @dump_truck_factory.build_controller(
      :simulation => @simulation,
      :dump_truck => @dump_truck,
      :viewport_controller => @viewport_controller
    )

    @viewport_controller.follow_target = @dump_truck
    @viewport_controller.follow_the_target

    put_dump_truck_in_start_position
    
    @workshop_zones_controller.watch(@dump_truck)

    @crate_controller = @crate_factory.build_controller(
      @simulation,
      @svg_loader.get_layer_from_file("terrain_proto.svg", "crates")
    )

    #
    # Event dispatching
    #
    @simulation.on :update_frame do |info|
      @update_frame_targets.each do |t|
        t.update_frame info
      end
    end

    @simulation.on :update_space do |info|
      @update_space_targets.each do |t|
        t.update_space info
      end
    end

    @simulation.on :draw_frame do |info|
      @draw_targets.each do |t|
        t.draw info
      end
    end

    # Level control
    @mode.on :button_down do |id,info|
      case id
      when Gosu::Button::KbEscape
        @mode.abort_level
      when Gosu::Button::KbF1
        @mode.complete_level
      end
    end
  end
  
  def add_to_simulation(obj)
    if obj.respond_to?(:add_to_simulation)
      obj.add_to_simulation(@simulation)
    else
      if obj.respond_to?(:draw)
        @draw_targets << obj
      end
      if obj.respond_to?(:update_space)
        @update_space_targets << obj
      end
      if obj.respond_to?(:update_frame)
        @update_frame_targets << obj
      end
    end
  end

  def put_dump_truck_in_start_position
    layer = @svg_loader.get_layer_from_file("terrain_proto.svg", "positions")
    img = layer.image("game:handle" => "truck_start")
    start_position = img.bounds.center
  
    @dump_truck.cold_drop start_position
  end

end
