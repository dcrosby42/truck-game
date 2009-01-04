require 'rexml/document'
require 'strscan'

class SvgDocument

  def initialize(xml_string)
    @document = REXML::Document.new(xml_string)
    @root = @document.root
  end

  def find_group_by_label(label)
    g = REXML::XPath.first(@root, "//g[@inkscape:label='#{label}']")
    return nil unless g
    Group.new(g)
  end

  class Bounds
    attr_reader :x, :y, :width, :height, :left, :right, :top, :bottom, :center_point
    def initialize(x,y,width,height)
      @x,@y,@width,@height = x,y,width,height
      calc_edges_and_center
    end

    def translate(vec)
      @x += vec.x
      @y += vec.y
      calc_edges_and_center
    end

    def recenter_on_zero
      @x = @x - @center_point.x
      @y = @y - @center_point.y
      calc_edges_and_center
    end

    def vertices
      @vertices ||= [
        vec2( @left,  @top    ),
        vec2( @left,  @bottom ),
        vec2( @right, @bottom ),
        vec2( @right, @top    ),
      ]
    end

    def dup
      Bounds.new(@x,@y,@width,@height)
    end

    private
    def calc_edges_and_center
      @left = @x
      @top = @y
      @right = @left + @width
      @bottom = @top + @height
      @center_point = vec2(@left + @width/2.0, @top + @height/2.0)
      @vertices = nil
    end
  end


  module HasBounds
    attr_accessor :bounds

    def translate(vec)
      @bounds.translate(vec) if @bounds
    end

    protected

    def set_bounds_from_attributes
      x = @node.attributes["x"].to_f
      y = @node.attributes["y"].to_f
      width = @node.attributes["width"].to_f
      height = @node.attributes["height"].to_f
      @bounds = Bounds.new(x,y,width,height)
    end
  end

  module HasTranslation
    def translation
      transform = @node.attributes["transform"]
      if transform and transform =~ /translate\(\s*(.+?)\s*,\s*(.+?\)\s*)/
        vec2($1.to_f, ty = $2.to_f)
      else
        ZeroVec2
      end
    end
  end

  class Base
    include HasTranslation
    attr_reader :node

    def initialize(node)
      raise "Can't make #{self.class.name} from nil" if node.nil?
      @node = node
    end

    def game_class
      @node.attributes['game:class']
    end

    def game_handle
      @node.attributes['game:handle']
    end
  end

  class Group < Base
    def paths(opts={})
      inst_from_xpath "path", Path, opts
    end

    def path(opts={})
      paths(opts).first
    end

    def rects(opts={})
      inst_from_xpath "rect", Rect, opts
    end

    def rect(opts={})
      rects(opts).first
    end

    def images(opts={})
      inst_from_xpath "image", Image, opts
    end

    def image(opts={})
      images(opts).first
    end

    def groups(opts={})
      inst_from_xpath "g", Group, opts
    end

    def group(opts={})
      groups(opts).first
    end

    private

    def map_from_xpath(xpr, opts={})
      opts.each do |key,val|
        xpr << "[@#{key}='#{val}']"
      end
      REXML::XPath.match(@node, xpr).map do |n|
        yield n
      end
    end

    def inst_from_xpath(xpr, clazz, opts={})
      map_from_xpath(xpr,opts) do |n|
        clazz.new(n)
      end
    end
  end

  class Path < Base
    # The bezier path object must have all its nodes turned "sharp",
    # or non-curve-handle-ish, or this parser will not work properly
    def vertices
      unless @verts
        @verts = []
        data = @node.attributes['d']
        scanner = StringScanner.new(data)
        pat = /[ML]\s+([-0-9.,]+)\s*/
        hit = scanner.scan(pat)
        while hit
          x,y = scanner[1].split(/,/).map { |s| s.to_f }
          @verts << vec2(x,y)
          hit = scanner.scan(pat)
        end
      end
      @verts
    end
  end

  class Rect < Base
    include HasBounds

    def initialize(node)
      super node
      set_bounds_from_attributes
    end
  end

  class Image < Rect
    attr_reader :image_name

    def initialize(node)
      super(node)
      @image_name = @node.attributes["xlink:href"]
    end
  end
end
