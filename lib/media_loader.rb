require 'svg_document'

class MediaLoader
  constructor :main_window

  def load_image(filename,hard_edge=false)
    caching filename do |f|
      Gosu::Image.new(@main_window, f, hard_edge)
    end
  end

  def image_from_text(*args)
    Gosu::Image.from_text(@main_window, *args)
  end

  def load_sample(filename)
    caching filename do |f|
      Gosu::Sample.new(@main_window, f)
    end
  end

  def load_song(filename)
    caching filename do |f|
      Gosu::Song.new(@main_window, f)
    end
  end

  def load_default_font(height)
    Gosu::Font.new(@main_window, Gosu::default_font_name, height)
  end

  def rmagick_to_gosu_image(rmagick_image, hard_edge=false)
    Gosu::Image.new(@main_window, rmagick_image, hard_edge)
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
