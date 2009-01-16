class TruckLevel1Setup
  constructor :mode, :simulation, :terrain_factory, :background_factory, :dump_truck_factory, :viewport_controller, :svg_loader, :crate_factory, :physical_factory, :media_loader, :scenery_factory, :joint_factory, :shape_drawing do

    @draw_targets = []
    @update_space_targets = []
    @update_frame_targets = []

    @level_config_svg = "truck_level_1.svg"

    @terrain = @terrain_factory.load_from_file(@level_config_svg)
    add_to_simulation @terrain

    @background = @background_factory.build(:image_name => "sky.png")
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
    
#    setup_boxes
    
#    @workshop_zones_controller.watch(@dump_truck)

    setup_crates

    setup_scenery

#    setup_paddle_experiment

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
    layer = get_layer("positions")
    img = layer.image("game:handle" => "truck_start")
    start_position = img.bounds.center
  
    @dump_truck.cold_drop start_position
  end

  def setup_crates
    @crates_controller = @crate_factory.build_controller(
      @simulation,
      get_layer("crates")
    )
  end

  def setup_boxes
    @boxes = []
    box_svgs = get_layer("boxes").images("game:class" => "wood_box")
    box_svgs.each do |box_def|
      loc = box_def.center
      bounds = box_def.bounds.dup
      bounds.set(bounds.x, bounds.y, bounds.width-2, bounds.height-2)
      polygon = bounds.to_polygon
      polygon.translate(-loc)
      box = @physical_factory.build_image_poly(
        :polygon => polygon,
        :image => @media_loader.load_image(box_def.image_name, true),
        :z_order => ZOrder::Box
      )
      box.move_to loc
      @boxes << box
    end

    @boxes.each do |box|
      add_to_simulation box
    end
  end

  def setup_scenery
    @scenery = @scenery_factory.build(get_layer("scenery"))
    add_to_simulation @scenery
  end

  def get_layer(layer_name)
    layer = @svg_loader.get_layer_from_file(@level_config_svg, layer_name)
  end

  def setup_paddle_experiment
    return
    svg_rect = get_layer("proto").rect("game:handle" => "paddle")
    polygon = svg_rect.bounds.to_polygon
    loc = polygon.center
    polygon.translate(-loc)
    box = @physical_factory.build_poly(
      :polygon => polygon, 
      :location => loc, 
      :mass => 10,
      :group => :exp)
    anchor = @physical_factory.build_poly(
      :as_anchor => true, 
      :polygon => Rectangle.new(-5,-5,10,10).to_polygon, 
      :location => loc, 
      :group => :exp)
    pivot = @joint_factory.new_pivot(
      :body_a => anchor.body,
      :body_b => box.body,
      :pivot_point => loc,
      :auto_add => true
    )

    @simulation.on :button_down do |id,info|
      case id
      when Gosu::Button::KbP
        puts "PUSH ON RIGHT"
        box.body.apply_force(vec2(0,-100), vec2(50,0))
      when Gosu::Button::KbU
        puts "PUSH ON LEFT"
        box.body.apply_force(vec2(0,-100), vec2(-50,0))
      when Gosu::Button::KbY
        puts "RESET"
        box.body.reset_forces
      end
    end

#    @simulation.on :update_space do |info|
#      if info.button_down?(Gosu::Button::KbP)
#        box.body.apply_force(vec2(0,-100), vec2(50,0))
#      end
#      if info.button_down?(Gosu::Button::KbU)
#        box.body.apply_force(vec2(0,-100), vec2(-50,0))
#      end
#      if info.button_down?(Gosu::Button::KbY)
#      end
#    end

    @simulation.on :draw_frame do |info|
      puts box.body.f
      @shape_drawing.draw_physical_poly(info, box)
    end
  end

end
