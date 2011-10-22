class BallController
  constructor :mode, :physical_factory do
    circle = @physical_factory.build_circle(
      :location => vec2(200,200),
      :radius => 30,
      :mass => 100
    )

    ball = Ball.new(circle)
    ball_adapter = ControlAdapter.new({
      Gosu::Button::KbA => ball.method(:roll_left),
      Gosu::Button::KbS => ball.method(:roll_right)
    })

    circle2 = @physical_factory.build_circle(
      :location => vec2(400,200),
      :radius => 20,
      :mass => 80
    )

    ball2 = Ball.new(circle2)
    ball2_adapter = ControlAdapter.new({
      Gosu::Button::KbH => ball2.method(:roll_left),
      Gosu::Button::KbL => ball2.method(:roll_right)
    })

    @mode.on :update do |info|
      ball_adapter.update(info)
      ball2_adapter.update(info)
    end

    @mode.on :draw do |info| 
      ball.draw info.window
      ball2.draw info.window
    end
  end

  class ControlAdapter
    def initialize(map)
      @map = map
    end

    def update(info)
      @map.each do |k,v|
        if info.button_down?(k)
          v.call
        end
      end
    end
  end

  class Ball
    include Gosu

    def initialize(circle)
      @circle = circle
      @body = @circle.body
      @color = 0xffffffff
      @z_order = 1
    end

    def draw(window)
      x, y = @body.p.x, @body.p.y
      draw_circle(window, x,y, @body.a, @circle.radius, @color, @z_order)

      # ex = x + offset_x(radians_to_gosu(@body.a), @circle.radius)
      # ey = y + offset_y(radians_to_gosu(@body.a), @circle.radius)
      ex = x + offset_x(@body.a.radians_to_gosu, @circle.radius)
      ey = y + offset_y(@body.a.radians_to_gosu, @circle.radius)
      window.draw_line(x,y,@color, ex,ey,@color, @z_order)
    end

    SPIN_INC = 1
    SPIN_MAX = 30
    def roll_right
      angvel = @body.w
      angvel += SPIN_INC
      angvel = SPIN_MAX if angvel > SPIN_MAX
      @body.w = angvel
    end

    def roll_left
      angvel = @body.w
      angvel -= SPIN_INC
      angvel = SPIN_MAX if angvel < (0.0 - SPIN_MAX)
      @body.w = angvel
    end

    private

    def draw_circle(window, x,y,ang,r,color,z=0,mode=:default,circle_step=10)
      ang = ang.radians_to_gosu
      0.step(360, circle_step) { |a1| 
        a1 += ang
        a2 = a1 + circle_step
        window.draw_line(x + offset_x(a1, r), y + offset_y(a1, r), color, 
                         x + offset_x(a2, r), y + offset_y(a2, r), color, z, mode)
      }
    end
  end
 
end
