#require 'rubygems'
#require 'RMagick'

class YardGround
  GROUND_ELASTICITY = 0.4
  GROUND_FRICTION = 0.9

  constructor :space_holder, :screen_info, :media_loader, :svg_rectangle_loader do
    setup_art_and_body
  end

  def draw
    @bg_photo.draw(0,0,ZOrder::Background)
#    @debug_image.draw(0,0,ZOrder::Background)

  end

  private 

  def setup_art_and_body

    @bg_photo = @media_loader.load_image("hayfield-sideview.png")

#    setup_graph_paper

    load_rectangles_from_svg.each do |r|
      construct_and_add r
    end

#    stamp_gosu_image
  end

  def construct_and_add(polygon_points)
    build_static_shape polygon_points
    #generate_debug_image polygon_points
  end

  def setup_graph_paper
    @graph_paper = Magick::Image.new(
                       @screen_info.screen_width, 
                       @screen_info.screen_height,
                       Magick::HatchFill.new('white','lightcyan2'))
  end

  def generate_debug_image(polygon_points)
    gc = Magick::Draw.new
    gc.stroke_width(2)
    gc.stroke('green')
    gc.fill('yellow')
    gc.polygon( *polygon_points.flatten ) 
    gc.draw(@graph_paper)
  end

  def stamp_gosu_image
    @debug_image = @media_loader.rmagick_to_gosu_image(@graph_paper,true)
  end

  def build_static_shape(polygon_points)
    body = CP::Body.new(Float::MAX, Float::MAX)

    shape_verts = polygon_points.map do |x,y| 
      CP::Vec2.new(x,y) 
    end.reverse

    shape = CP::Shape::Poly.new(body, shape_verts, CP::Vec2.new(0,0))
    shape.e = GROUND_ELASTICITY
    shape.u = GROUND_FRICTION
    @space_holder.space.add_static_shape(shape)
  end

  def load_rectangles_from_svg
    fname = "#{APP_ROOT}/proto/sideview-rectangle-layout.svg"
    @svg_rectangle_loader.as_arrays_of_tuples(fname)
  end

end
