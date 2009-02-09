require 'depot_presenter'
require 'zone'
require 'depot'
require 'slider_machine'

class DepotFactory
  constructor :media_loader, 
    :slider_factory, 
    :picture_factory, 
    :fruitiverse

  def build(opts)
    depot_config = opts[:depot_config]
    vehicle = opts[:vehicle]

    switch_rect = depot_config.rect("game:handle" => "switch")
    switch_zone = Zone.new(switch_rect.bounds)

    bucket_rect = depot_config.rect("game:handle" => "bucket")
    bucket_zone = Zone.new(bucket_rect.bounds)

    depot_bucket = DepotBucket.new(
      :bucket_zone => bucket_zone,
      :fruitiverse => @fruitiverse
    )

    slider_g = depot_config.group("slider1")
    slider = @slider_factory.build_left_slider(slider_g)

    slider_machine = SliderMachine.new(
      :slider => slider, 
      :start_sound => @media_loader.load_sample("slider_start.wav"),
      :roll_sound => @media_loader.load_sample("slider_rolling.wav"),
      :lock_sound => @media_loader.load_sample("slider_lock.wav")
    )

    depot_switch = DepotPresenter::DepotSwitch.new(
      :switch_zone => switch_zone, 
      :vehicle => vehicle
    )

    presenter = DepotPresenter.new(
      :slider_machine => slider_machine, 
      :depot_switch => depot_switch
    )

    depot_sign = DepotSign.new(
      :sign_picture => @picture_factory.build(:svg_image => depot_config.image("game:handle" => "sign"), :z_order => ZOrder::Scenery),
      :placard_picture => @picture_factory.build(:svg_image => depot_config.image("game:handle" => "placard"), :z_order => ZOrder::Scenery),
      :fruit_icon_picture => @picture_factory.build(:svg_image => depot_config.image("game:handle" => "fruit_icon"), :z_order => ZOrder::Scenery),
      :counter_font => @media_loader.load_default_font(30)
    )

    Depot.new(
      :slider => slider,
      :slider_machine => slider_machine,
      :depot_switch => depot_switch,
      :zone => switch_zone,
      :depot_bucket => depot_bucket,
      :depot_sign => depot_sign
    )
  end

  class DepotSign
    constructor :sign_picture, :placard_picture, :fruit_icon_picture, :counter_font
    def setup
      @drawables = [
        @sign_picture,
        @placard_picture,
        @fruit_icon_picture
      ]
      @text_loc = @placard_picture.center + vec2(0,0)
      puts @text_loc
      @counter_font_color = 0xffFFFFFF
    end

    def draw(info)
      @drawables.each do |d| d.draw(info) end
      @counter_font.draw_rel("10/10",
                             info.view_x(@text_loc.x)+20, info.view_y(@text_loc.y), ZOrder::Scenery,
                             0.5, 0.5,
                             1,1,
                             @counter_font_color)
    end
  end

  class DepotBucket
    constructor :bucket_zone, :fruitiverse

    def setup
      @fruits = []
    end

    def update_frame(info)
      @fruits = @fruitiverse.fruits.select do |fruit|
        @bucket_zone.contains?(fruit)
      end
    end

    def draw(info)
      @bucket_zone.draw(info)
    end
    
    def shape
      @physical_poly.shape
    end
  end
end
