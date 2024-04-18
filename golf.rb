require 'ruby2d'

set title: 'Golf Med Vänner'
set width: 1024
set height: 768
set background: 'green'

class Ball
  attr_accessor :x , :y, :velocity, :angle

  def initialize(x_init, y_init)
    @x = x_init
    @y = y_init
    @velocity = 0;
    @angle = 0;
    @shape = Circle.new(x: @x, y: @y,
    radius: 25, color: 'white')
  end

  def move
    @x = @x + @velocity*cos(@angle)
    @y = @y + @velocity*sin(@angle)
    @shape.x = @x
    @shape.y = @y
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

velocity_x = 0
velocity_y = 0
acceleration = 0.5
friction = 0.97

golfball = Ball.new(300,300)
hole = Hole.new(400,400)


on :mouse_down do |event|
 

end

update do
  golfball.move
end



show
