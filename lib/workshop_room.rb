
class WorkshopRoom
  constructor :mode,
    :simulation,
    :terrain_factory,
    :background_factory,
    :dump_truck_factory,
    :viewport_controller,
    :svg_loader,
    :depot_factory,
    :media_loader,
    :physical_factory,
    :shape_registry,
    :crate_factory do

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
      :dump_truck => @dump_truck
    )

    @viewport_controller.follow_target = @dump_truck
    @viewport_controller.follow_the_target

    put_dump_truck_in_start_position
    
    @crate_controller = @crate_factory.build_controller(
      @simulation,
      @svg_loader.get_layer_from_file("terrain_proto.svg", "crates")
    )

    depots_layer = @svg_loader.get_layer_from_file("terrain_proto.svg", "depots")
    [ "lettuce", "apple", "strawberry", "banana" ].each do |fruit|
      depot_g = depots_layer.group("#{fruit}_depot")
      next unless depot_g
      depot = @depot_factory.build(
        :depot_config => depot_g,
        :vehicle => @dump_truck
      )
      add_to_simulation depot
    end

    setup_boxes

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

  def setup_boxes
    layer_g = @svg_loader.get_layer_from_file("terrain_proto.svg", "boxes")
    @boxes = []
    box_svgs = layer_g.images("game:class" => "wood_box")
    box_svgs.each do |box_def|
      loc = box_def.center
      bounds = box_def.bounds.dup
      bounds.set(bounds.x, bounds.y, bounds.width-2, bounds.height-2)
      polygon = bounds.to_polygon
      polygon.translate(-loc)
      box = @physical_factory.build_image_poly(
        :polygon => polygon,
        :image => @media_loader.load_image(box_def.image_name, true),
        :mass => 5,
        :friction => 0.9,
        :elasticty => 0.5,
        :z_order => ZOrder::Box
      )
      box.move_to loc
      @shape_registry.add(box.shape, box)
      @boxes << box
    end

    @boxes.each do |box|
      add_to_simulation box
    end
  end

end
