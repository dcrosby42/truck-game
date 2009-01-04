require 'crate'

class CrateFactory
  constructor :picture_factory

  def build_crate_set(crate_layer)
    crate_set = CrateSet.new
    
    crate_layer.groups("game:class" => "crate").each do |g|
      box_picture = build_picture(g, "box", ZOrder::Crate)
      icon_picture = build_picture(g, "icon", ZOrder::CrateIcon)

      c = Crate.new(
        :handle => g.game_handle,
        :bounds => box_picture.bounds,
        :box_picture => box_picture,
        :icon_picture => icon_picture
      )
      crate_set.add c
    end

    crate_set
  end

  def build_picture(g, game_class, z)
    svg_image = g.image("game:class" => game_class)
    svg_image.translate g.translation
    @picture_factory.build(:svg_image => svg_image, :z_order => z)
  end

  class CrateSet
    def initialize
      @array = []
      @hash = {}
    end

    def add(crate)
      @array << crate
      @hash[crate.handle] = crate
    end

    def get(handle)
      @hash[handle]
    end
    
    def each(&block)
      @array.each &block
    end
  end
end
