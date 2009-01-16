class ShapeDrawing
  def draw_physical_poly(info, physical_poly, color=nil)
    color ||= 0xffffffff
    window = info.window
    physical_poly.world_vertices.each_edge do |a,b|
      a = info.view_point(a)
      b = info.view_point(b)
      window.draw_line(a.x,a.y,color,
                       b.x,b.y,color, ZOrder::Debug+1)
    end
  end
end
