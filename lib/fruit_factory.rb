require 'fruit'

class FruitFactory
  constructor :space_holder, :media_loader, :workshop_svg_holder

  def build_apple
    unless @apple_verts 
      # Find the apple definition in the svg layout
      fruit_layer = @workshop_svg_holder.get_layer("fruits")
      apple_g = fruit_layer.group("game:handle" => "apple")

      # Grab the image def
      svg_image = apple_g.image
      image_name = svg_image.image_name

      # Grab the polygon def
      polygon = apple_g.path
      verts = polygon.vertices.dup

      # Adjust path vertices to be centered on the center of the image
      image_center = svg_image.bounds.center_point
      verts = verts.map do |v|
        v - image_center
      end
#      verts.pop
      #verts.reverse!

      @apple_verts = verts
      @apple_image = @media_loader.load_image(image_name)
    end
    
    Fruit.new(
      :space => @space_holder.space,
      :image => @apple_image,
      :verts => @apple_verts
    )
#        vec2(5,2), 
#        vec2(3,-5), 
#        vec2(-3,-5), 
#        vec2(-5,2), 
#        vec2(0,5)
#      ]
#    )
  end

  def build_banana
  end

  def build_strawberry
  end
end
