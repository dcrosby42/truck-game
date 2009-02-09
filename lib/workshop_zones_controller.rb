require 'zone'
class WorkshopZonesController
  constructor :simulation, :media_loader, :svg_loader do
    load_zones
    @watched = []

    @simulation.on :draw_frame do |info|
#      @zones.each do |z|
#        z.draw(info)
#      end
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
    g = @svg_loader.get_layer_from_file("terrain_proto.svg", "zones")
    @zones = g.rects.map do |rect|
      Zone.new(rect)
    end
  end

  def update_zone_inclusions
#    @zones.each do |z|
#      @watched.each do |obj|
#        if z.contains_point?(obj.location)
##          puts "IN ZONE #{z.object_id}"
#        end
#      end
#    end
  end

end
