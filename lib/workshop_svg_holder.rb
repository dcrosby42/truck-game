class WorkshopSvgHolder
  constructor :media_loader do
    @svg = @media_loader.load_svg_document("terrain_proto.svg")
  end

  def get_layer(label)
    g = @svg.find_group_by_label(label)
    raise "Can't find SVG layer '#{label}'" if g.nil?
    g
  end
end
