class WorkshopSvgHolder
  constructor :svg_loader
  def get_layer(label)
    @svg_loader.get_layer_from_file("terrain_proto.svg", label)
  end
end
