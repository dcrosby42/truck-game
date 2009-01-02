require 'rexml/document'
require 'strscan'

class SvgDocument
  include REXML

  def initialize(xml_string)
    @document = Document.new(xml_string)
    @root = @document.root
  end

  def find_group_by_label(label)
    Group.new XPath.first(@root, "//g[@inkscape:label='#{label}']")
  end

  class Group
    include REXML
    def initialize(node)
      @group = node
    end

    def path
      path = XPath.first(@group, "path")
      if path
        Path.new(path)
      else
        nil
      end
    end

    def rects
      XPath.match(@group, "rect").map { |r| Rect.new(r) }
    end
  end

  class Path
    include REXML

    def initialize(node)
      @path = node
    end

    # The bezier path object must have all its nodes turned "sharp",
    # or non-curve-handle-ish, or this parser will not work properly
    def vertices
      unless @verts
        @verts = []
        data = @path.attributes['d']
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

  class Rect
    attr_reader :node, :x, :y, :width, :height
    def initialize(node)
      @node = node
      @x = node.attributes["x"].to_f
      @y = node.attributes["y"].to_f
      @width = node.attributes["width"].to_f
      @height = node.attributes["height"].to_f
    end
  end
end
