require 'svg_document'

class MediaLoader

  def load_image(filename,hard_edge=false)
    caching filename do |f|
      Gosu::Image.new(f, tileable: hard_edge)
    end
  end

  def image_from_text(text,opts)
    line_height = opts.delete(:line_height) || opts.delete(:size) || raise(":line_height option required")
    Gosu::Image.from_text(text, line_height, opts)
  end

  def load_sample(filename)
    caching filename do |f|
      Gosu::Sample.new(f)
    end
  end

  def load_song(filename)
    caching filename do |f|
      Gosu::Song.new(f)
    end
  end

  def load_default_font(height)
    Gosu::Font.new(height, name: Gosu::default_font_name)
  end

  def rmagick_to_gosu_image(rmagick_image, hard_edge=false)
    Gosu::Image.new(rmagick_image, tileable: hard_edge)
  end

  def load_svg_document(filename)
    caching filename do |f|
      SvgDocument.new(File.read(f))
    end
  end

  private 

  def caching(filename)
    media_filename = "media/#{filename}"
    @media_cache ||= {}
    media = @media_cache[media_filename]
    unless media
      media = yield(media_filename)
      @media_cache[media_filename] = media
    end
    media
  end

end
