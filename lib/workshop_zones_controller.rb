class WorkshopZonesController
  constructor :simulation, :media_loader, :workshop_svg_holder do
    load_zones
    @watched = []

    @simulation.on :draw_frame do |info|
      @zones.each do |z|
        z.draw(info)
      end
    end

    @simulation.on :update_frame do |info|
      update_zone_inclusions
    end
  end

  def watch(object)
    @watched << object
  end

  private
  def load_zones
    g = @workshop_svg_holder.get_layer("zones")
    @zones = g.rects.map do |rect|
      Zone.new(rect)
    end
  end

  def update_zone_inclusions
    @zones.each do |z|
      @watched.each do |obj|
        if z.contains_point?(obj.location)
          puts "IN ZONE #{z.object_id}"
        end
      end
    end
  end

  class Zone
    def initialize(rect)
      @rect = rect
      @center_x = @rect.x + (@rect.width / 2.0)
      @center_y = @rect.y + (@rect.height / 2.0)
      @radius = @rect.width / 2.0
    end

    def contains_point?(loc)
      Gosu::distance(@center_x,@center_y, loc.x, loc.y) <= @radius
    end

    def draw(info)
      top = info.view_y(@rect.y)
      bottom = top + @rect.height
      left = info.view_x(@rect.x)
      right = left + @rect.width
      color = 0x660000ff
      info.window.draw_quad(left,top,color,
                            right,top,color,
                            left,bottom,color,
                            right,bottom,color,
                            ZOrder::Debug)
    end
  end
end
