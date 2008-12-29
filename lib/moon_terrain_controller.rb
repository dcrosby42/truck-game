require 'chipmunk'

class MoonTerrainController
  TERRAIN_ELASTICITY = 0.0
  TERRAIN_FRICTION = 0.9

  constructor :mode, :space_holder, :main_window, :viewport do
    setup_terrain

    @mode.on :draw do |info|
      draw_terrain
    end

    @mode.on :button_down do |id, info|
      if Gosu::KbEscape == id
        @mode.complete_level
      end
    end

  end

  private 

  def draw_terrain
    white = 0xffffffff
    px = py = nil
    terrain_data.each_with_index do |height, i|
      x = @viewport.ox(i * 50)
      y = @viewport.oy(1000 - height)
      @main_window.draw_line(px,py,white, x,y,white) if px
      px = x
      py = y
    end
  end

  def setup_terrain
    body = CP::Body.new(Float::MAX, Float::MAX)

    px = py = nil
    terrain_data.each_with_index do |height, i|
      x = i * 50
      y = 1000 - height
      if px
        shape = CP::Shape::Segment.new(
                 body,
                 CP::Vec2.new(px,py),    # from
                 CP::Vec2.new(x,y),      # to
                 0.0)                    # radius (dunno what this is for)
        shape.e = TERRAIN_ELASTICITY
        shape.u = TERRAIN_FRICTION
        @space_holder.space.add_static_shape(shape)
      end
      px = x
      py = y
    end

  end

  def terrain_data
    @terrain_data ||= [
    660.00, 660.00, 660.00, 660.00, 673.21, 688.42, 694.56, 692.55,
    685.40, 676.12, 667.75, 662.45, 658.93, 655.42, 650.17, 641.49,
    627.92, 610.08, 589.01, 565.71, 541.23, 516.58, 492.56, 469.57,
    447.97, 428.13, 410.60, 397.25, 392.66, 394.89, 400.70, 406.82,
    410.93, 413.87, 416.91, 421.30, 428.24, 436.05, 440.41, 437.09,
    421.93, 394.41, 355.57, 308.78, 257.99, 207.18, 160.31, 120.81,
    89.20, 65.17, 48.43, 38.67, 36.68, 45.03, 64.17, 92.26, 128.76,
    173.27, 224.20, 278.84, 334.48, 388.43, 438.31, 483.95, 525.96,
    564.95, 601.54, 633.88, 655.05, 665.87, 667.79, 662.25, 650.01,
    629.92, 604.68, 577.50, 551.55, 529.69, 512.49, 502.04, 500.20,
    502.72, 508.57, 518.31, 531.15, 545.99, 561.70, 577.30, 593.74,
    610.97, 628.13, 644.35, 658.81, 672.13, 684.78, 696.72, 708.00,
    718.65, 728.17, 736.14, 742.62, 747.63, 751.20, 752.58, 750.20,
    743.02, 730.05, 709.98, 682.99, 651.49, 616.61, 579.47, 541.18,
    503.87, 471.12, 444.10, 423.86, 411.44, 407.95, 414.29, 430.28,
    453.64, 482.36, 514.10, 545.66, 577.48, 610.42, 645.32, 682.66,
    719.61, 754.76, 787.26, 816.26, 840.95, 861.10, 876.94, 888.71,
    896.61, 900.84, 900.46, 894.59, 882.69, 864.24, 838.69, 805.77,
    765.56, 718.19, 670.07, 626.07, 586.87, 551.65, 518.20, 484.33,
    447.81, 408.39, 367.51, 324.70, 279.44, 231.25, 181.20, 134.59,
    96.96, 66.40, 40.75, 18.74, 1.97, -8.96, -13.56, -11.33, -2.28,
    11.64, 29.88, 52.04, 78.07, 108.53, 139.94, 171.90, 204.54,
    238.00, 272.25, 305.61, 336.90, 365.19, 389.61, 409.28, 424.38,
    434.79, 438.85, 437.12, 431.08, 422.77, 412.26, 398.92, 382.10,
    361.16, 336.82, 311.06, 285.61, 262.18, 242.50]
  end

  
end
