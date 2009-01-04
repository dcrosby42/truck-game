require 'picture'

class PictureFactory
  constructor :media_loader

  def build(opts)
    data = {
      :z_order => 0
    }.merge(opts)

    svg_image = data[:svg_image]
    gosu_image = @media_loader.load_image(svg_image.image_name, true)
    Picture.new(
      :image => gosu_image, 
      :bounds => svg_image.bounds, 
      :z_order => data[:z_order]
    )
  end
end
