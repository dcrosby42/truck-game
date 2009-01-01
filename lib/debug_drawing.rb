module DebugDrawing

  def draw_cross_at_vec2(window, pt, color=0xffff0000)
    window.draw_line(pt.x,pt.y,color,
                     pt.x,pt.y-5,color, ZOrder::Debug+1)
    window.draw_line(pt.x,pt.y,color,
                     pt.x+5,pt.y,color, ZOrder::Debug+1)
  end

  def draw_circle(opts)
    data = {
      :x => 0, :y => 0, :r => 10,
      :circle => nil,
      :degress => 0.0,
      :color => 0xffffffff,
      :z_order => ZOrder::Debug,
      :mode => :default,
      :circle_step => 10,
      :draw_radius => true
    }.merge(opts)

    window = data[:window] || raise("can't draw without window")
    x,y,r = data[:x], data[:y], data[:r]
    if data[:circle]
      loc = data[:circle].p
      x,y = loc.x, loc.y
      r = data[:circle].radius
    end
    degrees = data[:degrees]
    color = data[:color]
    circle_step = data[:circle_step]
    z_order = data[:z_order]
    mode = data[:mode]

    0.step(360, circle_step) { |a1| 
      a1 += degrees
      a2 = a1 + circle_step
      window.draw_line(x + offset_x(a1, r), y + offset_y(a1, r), color, 
                       x + offset_x(a2, r), y + offset_y(a2, r), color, z_order, mode)
    }

    if data[:draw_radius]
      ex = x + offset_x(degrees, r)
      ey = y + offset_y(degrees, r)
      window.draw_line(x,y,color, ex,ey,color, z_order)
    end
  end
end
