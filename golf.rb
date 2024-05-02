require 'ruby2d'

set title: 'Golf'
set width: 1024
set height: 768
set background: 'green'

class Ball
  attr_accessor :x , :y, :velocity, :angle, :radius

  def initialize(x_init, y_init, radius)
    @x = x_init
    @y = y_init
    @xv = 0
    @yv = 0
    @velocity = 0
    @angle = 0
    @radius = radius
    @shape = Circle.new(
      x: @x,
      y: @y,
      radius: radius,
      color: 'white'
    )
  end

  def shoot
    @xv = @velocity*Math.cos(@angle)
    @yv = @velocity*Math.sin(@angle)
  end

  def move
    @x = @x + @xv # @velocity*Math.cos(@angle)
    @y = @y + @yv  #@velocity*Math.sin(@angle)

    @shape.x = @x
    @shape.y = @y
    @xv *= 0.95
    @yv *= 0.95


    if hit_bottom? || hit_top?
      @yv = -@yv
    end
    if hit_left? || hit_right?
      @xv = -@xv
    end

  end

  def hit_bottom?
    @y + @radius >= Window.height
  end

  def hit_top?
    @y <= 0
   end

   def hit_left?
    @x <= 0
   end

   def hit_right?
    @x + @radius >= Window.width
   end
end

class Obstacle
  attr_accessor :x, :y
  def initialize(x_init, y_init)
    @x = x_init
    @y = y_init
    @rectangle = Rectangle.new(x: @x, y: @y, height: 250, width: 90, color: 'red')
  end
end

class Hole
  attr_accessor :x , :y, :radius

  def initialize(x_init, y_init, radius)
    @x = x_init
    @y = y_init
    @radius = radius
    @goal = Circle.new(x: @x, y: @y, radius: @radius, color: 'black')
  end
end

golfball = Ball.new(rand(100..300),rand(100..600),25)
hole = Hole.new(rand(400..700),rand(200..700), 40)
rectangle = Obstacle.new(500, 200)

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

  golfball.velocity = Math.sqrt((xu-xd)**2 + (yu-yd)**2) * 0.1
  golfball.angle = Math.atan2(yu-yd, xu-xd) + Math::PI

  golfball.shoot
end

update do
  golfball.move

  if hole.radius > Math.sqrt((hole.x - golfball.x)**2 + (hole.y - golfball.y)**2)
    you_win = Text.new(
      'YOU WIN',
      y: 100,
      style: 'bold',
      size: 70)
    you_win.x = (Window.width - you_win.width)/2
    end
end


show
