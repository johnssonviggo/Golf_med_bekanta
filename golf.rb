require 'ruby2d'

set title: 'Golf'
set width: 1024
set height: 768
set background: 'green'

class Ball
  attr_accessor :x , :y, :velocity, :angle
  HEIGHT = 25
  def initialize(x_init, y_init)
    @x = x_init
    @y = y_init
    @velocity = 0;
    @angle = 0;
    @shape = Circle.new(x: @x, y: @y,
    radius: HEIGHT, color: 'white')
  end

  def move
    @x = @x + @velocity*Math.cos(@angle)
    @y = @y + @velocity*Math.sin(@angle)
    @shape.x = @x
    @shape.y = @y
    @velocity *= 0.97


    if hit_bottom? || hit_top?
      @velocity = -@velocity
    end
  end

  def hit_bottom?
    @y + HEIGHT >= Window.height
  end

  def hit_top?
    @y <= 0
   end
end

class Obstacle
end

class Hole
  attr_accessor :x , :y
  def initialize(x_init, y_init)
    @x = x_init
    @y = y_init
    @goal = Circle.new(x: 700, y: rand(200..700), radius: 40, color: 'black')
  end
end

golfball = Ball.new(300,300)
hole = Hole.new(400,400)

xd = 0
yd = 0
xu = 0
yu = 0


on :mouse_down do |event|

  xd = event.x
  yd = event.y

end

on :mouse_up do |event|
  xu = event.x
  yu = event.y

  golfball.velocity = Math.sqrt((xu-xd)^2+(yu-yd)^2)
  golfball.angle = Math.atan((yu-yd)/(xu-xd))



end


update do
  golfball.move
end


show
