require 'terrain'

class TerrainFactory
  constructor :svg_loader, :space_holder

  def load_from_file(file,layer="ground")
    g = @svg_loader.get_layer_from_file("terrain_proto.svg", "ground")
    build_from_vertices(g.path.vertices)
  end

  def build_from_vertices(vertices)
    moment_of_inertia,mass = Float::Infinity,Float::Infinity
    terrain_body = CP::Body.new(mass,moment_of_inertia)
    elasticity = 0.1
    friction = 0.7
    thickness = 0.5
    segments = []
    space = @space_holder.space
    vertices.each_segment do |a,b|
      seg = CP::Shape::Segment.new(terrain_body, a,b, thickness)
      seg.collision_type = :terrain
      seg.e = elasticity
      seg.u = friction
      seg.group = :terrain
      segments << seg
      space.add_shape(seg)
    end
    Terrain.new(:vertices => vertices, :segments => segments, :space => space)
  end
end
