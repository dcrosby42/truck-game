require 'fruit'

class FruitFactory
  constructor :space_holder, :media_loader, :workshop_svg_holder
  def setup
    @templates = {}
  end

  def build_apple
    new_fruit "apple"
  end

  def build_banana
    new_fruit "banana"
  end

  def build_strawberry
    new_fruit "strawberry"
  end

  private

  def new_fruit(kind)
    template = get_template(kind)
    Fruit.new(
      :space => @space_holder.space,
      :image => template.image,
      :verts => template.verts
    )
  end

  def get_template(kind)
    template = @templates[kind]
    if template.nil?
      # Find the fruit definition in the svg layout
      fruit_layer = @workshop_svg_holder.get_layer("fruits")
      g = fruit_layer.group("game:handle" => kind)

      # Grab the image def
      svg_image = g.image
      gosu_image = @media_loader.load_image(svg_image.image_name)

      # Grab the polygon def
      polygon = g.path
      verts = polygon.vertices.dup

      # Adjust path vertices to be centered on the center of the image
      image_center = svg_image.bounds.center_point
      verts = verts.map do |v|
        v - image_center
      end
      
      # SVG drawing may use closed path, which repeats the point of closure... we need to avoid that
      first = verts.first
      last = verts.last
      if Gosu::distance(first.x,first.y, last.x,last.y) < 0.001
        verts.pop
      end
      template = FruitTemplate.new(:verts => verts, :image => gosu_image)
      @templates[kind] = template
    end
    template
  end

  class FruitTemplate
    constructor :image, :verts, :accessors => true
  end
end
