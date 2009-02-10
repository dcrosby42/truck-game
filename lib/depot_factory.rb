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
    raise ":depot_config required" unless depot_config
    raise ":vehicle required" unless vehicle

    switch_rect = depot_config.rect("game:handle" => "switch")
    switch_zone = Zone.new(switch_rect.bounds.translate(depot_config.translation))

    bucket_rect = depot_config.rect("game:handle" => "bucket")
    bucket_zone = Zone.new(bucket_rect.bounds.translate(depot_config.translation))

    depot_bucket = DepotBucket.new(
      :bucket_zone => bucket_zone,
      :fruitiverse => @fruitiverse,
      :target_fruit_type => bucket_rect.game_attribute(:fruit_type)
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


    sign_image = depot_config.image("game:handle" => "sign")
    sign_image.translate(depot_config.translation)
    placard_image = depot_config.image("game:handle" => "placard")
    placard_image.translate(depot_config.translation)
    fruit_icon_image = depot_config.image("game:handle" => "fruit_icon")
    fruit_icon_image.translate(depot_config.translation)
    depot_sign = DepotSign.new(
      :sign_picture => @picture_factory.build(:svg_image => sign_image, :z_order => ZOrder::Scenery),
      :placard_picture => @picture_factory.build(:svg_image => placard_image, :z_order => ZOrder::Scenery),
      :fruit_icon_picture => @picture_factory.build(:svg_image => fruit_icon_image, :z_order => ZOrder::Scenery),
      :counter_font => @media_loader.load_default_font(30),
      :score_sound => @media_loader.load_sample("ring.wav")
    )

    presenter = DepotPresenter.new(
      :slider_machine => slider_machine, 
      :depot_switch => depot_switch,
      :depot_bucket => depot_bucket,
      :depot_sign => depot_sign
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
    constructor :sign_picture, :placard_picture, :fruit_icon_picture, :counter_font, :score_sound
    def setup
      @drawables = [
        @sign_picture,
        @placard_picture,
        @fruit_icon_picture
      ]
      @text_loc = @placard_picture.center + vec2(0,0)
      puts @text_loc
      @counter_font_color = 0xffFFFFFF
      @fruit_count = 0
    end

    def set_fruit_count(num)
      @score_sound.play(0.5) if num > @fruit_count
      @fruit_count = num
    end

    def draw(info)
      @drawables.each do |d| d.draw(info) end
      @counter_font.draw_rel("#{@fruit_count}/10",
                             info.view_x(@text_loc.x)+20, info.view_y(@text_loc.y), ZOrder::Scenery,
                             0.5, 0.5,
                             1,1,
                             @counter_font_color)
    end
  end

  require 'publisher'
  class DepotBucket
    constructor :bucket_zone, :fruitiverse, :target_fruit_type
    extend Publisher
    can_fire :fruit_count_changed

    def setup
      @fruits = []
    end

    def update_frame(info)
      old_count = @fruits.size
      @fruits = @fruitiverse.fruits.select do |fruit|
        @bucket_zone.contains?(fruit) and fruit.kind == @target_fruit_type
      end
      if @fruits.size != old_count
        fire :fruit_count_changed, @fruits.size
      end
    end

    def draw(info)
#      @bucket_zone.draw(info)
    end
    
    def shape
      @physical_poly.shape
    end
  end
end
