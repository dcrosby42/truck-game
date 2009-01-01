class RainController
  include Gosu
  include CP
  constructor :simulation, :space_holder, :media_loader do
    @blocks = []

    @simulation.on :update_space do |info|
      if info.button_down?(Button::KbSpace)
        add_block
      elsif info.button_down?(Button::KbTab)
        clear_blocks
      end
    end

    @simulation.on :draw_frame do |info|
      @blocks.each do |b|
        b.draw(info.window)
      end
    end
  end

  def add_block
    image = @media_loader.load_image('small_rock.png')
    b = Block.new(@space_holder.space, image)
    x = 500 + (rand(20)-10)
    y = 300
    b.body.p = vec2(x,y)
    @blocks << b
  end

  def clear_blocks
    while !@blocks.empty?
      b = @blocks.shift
      b.remove_from_space
    end
  end

  class Block
    attr_reader :body
    include Gosu
    include CP
    
    def initialize(space, image)
      @space = space
      @image = image
      @color = 0xffffffff
      @mass = 1
      @size = 6
#      moment_of_inertia = CP.moment_for_circle(@mass, @size,0, ZeroVec2)
      @bounds = [vec2(5,2), vec2(3,-5), vec2(-3,-5), vec2(-5,2), vec2(0,5)]
      moment_of_inertia = CP.moment_for_poly(@mass, @bounds, ZeroVec2)
      @body = CP::Body.new(@mass, moment_of_inertia)
#      @shape = CP::Shape::Circle.new(@body, @size, ZeroVec2)
      @shape = CP::Shape::Poly.new(@body, @bounds, ZeroVec2)
      @shape.collision_type = :block
      @shape.body.p = ZeroVec2
      @shape.e = 0.0
      @shape.u = 0.7
      @space.add_body(@body)
      @space.add_shape(@shape)

    end

    def remove_from_space
      @space.remove_body(@body)
      @space.remove_shape(@shape)
    end

    def draw(window)
      @image.draw_rot(@body.p.x, @body.p.y, 1, @body.a.radians_to_gosu)
#      @bounds.map { |v| @body.local2world(v) }.each_edge do |a,b|
#        window.draw_line(a.x,a.y,@color,
#                         b.x,b.y,@color)
#      end
    end

  end
end
