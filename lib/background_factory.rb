require 'background'

class BackgroundFactory
  constructor :media_loader

  def build(opts)
    Background.new(:image => @media_loader.load_image(opts[:image_name], true))
  end
end
