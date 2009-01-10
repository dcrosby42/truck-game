require 'fruit'

class FruitFactory
  constructor :space_holder, :media_loader, :workshop_svg_holder, :physical_factory, :svg_shape_parser
  def setup
    @templates = {}
  end

  def new_fruit(kind)
    template = get_template(kind)
    @physical_factory.build_image_poly(
      :image => template.image,
      :z_order => ZOrder::Fruit,
      :polygon => template.polygon,
      :mass => 1,
      :elasticity => 0.0
    )
  end

  def get_template(kind)
    template = @templates[kind]
    if template.nil?
      # Find the fruit definition in the svg layout
      fruit_layer = @workshop_svg_holder.get_layer("fruits")
      g = fruit_layer.group("game:handle" => kind)
      raise "Can't find a fruit for kind=#{kind}" if g.nil?

      # Grab the image def
      svg_image = g.image
      gosu_image = @media_loader.load_image(svg_image.image_name)

      # Grab the polygon def
      polygon = @svg_shape_parser.path_to_polygon(g.path)
      
      # Translate the Polygon's vertices to be centered on the image bounds
      polygon.translate( -svg_image.bounds.center )

      template = FruitTemplate.new(:polygon => polygon, :image => gosu_image)
      @templates[kind] = template
    end
    template
  end

  class FruitTemplate
    constructor :image, :polygon, :accessors => true
  end
end
