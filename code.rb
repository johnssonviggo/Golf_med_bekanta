require 'ruby2d'


def circle_hit_golfBall?(golfBall, circle)
    golfBall.contains?(circle.x, circle.y)
end

def golfBall_in_hole?(golfBall, hole)
    golfBall.contains?(hole.x, hole.y)
end


def check_collision_with_screen(ball)
    if ball.x <= 70 || ball.x >= ((Window.width - 30) - ball.radius * 2)
        return :x
    elsif ball.y <= 70 || ball.y >= ((Window.height - 30) - ball.radius * 2)
        return :y
    else
        return nil
    end
end


def check_collision_with_screen(ball)
    if ball.x <= 70 || ball.x >= ((Window.width - 30) - ball.radius * 2)
        return :x
    elsif ball.y <= 70 || ball.y >= ((Window.height - 30) - ball.radius * 2)
        return :y
    else
        return nil
    end
end

golfBall = Circle.new(x: 200, y: 300, radius: 20, color: 'white', z:10)
hole = Circle.new(x:700, y: 300, radius: 25, color: 'black', z:8)
map = Rectangle.new(x: 50, y: 50, width: 800, height: 600, color: '#109611')
obstacle1 = Rectangle.new(x: 500, y: 200, width:50, height:200, color: 'red')
obstacle2 = Rectangle.new(x: 500, y: 400, width:200, height:50, color: 'blue')


set width: 900, height: 700
set background: 'black'

start_position_x = nil
start_position_y = nil
first_time = true
velocity_x = 0
velocity_y = 0
acceleration = 0.5
friction = 0.95
mouse_down = false
count = 0

on :key_held do |event|
    case event.key
    when 'w'
        velocity_y -= acceleration
    when 's'
        velocity_y += acceleration
    when 'a'
        velocity_x -= acceleration
    when 'd'
        velocity_x += acceleration
    end
end

on :key_held do |event|
    case event.key
    when 'r'
        golfBall.x = 200
        golfBall.y = 300
        velocity_x = 0
        velocity_y = 0
    end
end


on :mouse_down do |event|
    case event.button
    when :left
        mouse_down = true

        circle = Circle.new(x: Window.mouse_x, y: Window.mouse_y, radius: 1)
        if circle && circle_hit_golfBall?(golfBall, circle) && first_time
            start_position_x = event.x
            start_position_y = event.y
            first_time = false
        end
        circle.remove
    end
end

on :mouse_up do |event|
    case event.button
    when :left
        mouse_down = false
        if !first_time
            velocity_x += (start_position_x - event.x) / 10.0
            velocity_y += (start_position_y - event.y) / 10.0
            first_time = true
        end
    end
end




update do




    if golfBall_in_hole?(golfBall, hole) && velocity_x < 7 && velocity_y < 7
        golfBall.x = 200
        golfBall.y = 300
        velocity_x = 0
        velocity_y = 0
    end

    collision = check_collision_with_screen(golfBall)

    if collision == :x
        velocity_x *= -1
    elsif collision == :y
        velocity_y *= -1
    end

    # Check collision with obstacle1
    if golfBall.x + golfBall.radius >= obstacle1.x && golfBall.x - golfBall.radius <= obstacle1.x + obstacle1.width &&
        golfBall.y + golfBall.radius >= obstacle1.y && golfBall.y - golfBall.radius <= obstacle1.y + obstacle1.height
        if golfBall.x + golfBall.radius >= obstacle1.x && golfBall.x < obstacle1.x && velocity_x > 0
            velocity_x *= -1
        elsif golfBall.x - golfBall.radius <= obstacle1.x + obstacle1.width && golfBall.x > obstacle1.x + obstacle1.width && velocity_x < 0
            velocity_x *= -1
        elsif golfBall.y + golfBall.radius >= obstacle1.y && golfBall.y < obstacle1.y && velocity_y > 0
            velocity_y *= -1
        elsif golfBall.y - golfBall.radius <= obstacle1.y + obstacle1.height && golfBall.y > obstacle1.y + obstacle1.height && velocity_y < 0
            velocity_y *= -1
        end
    end

    # Check collision with obstacle2
    if golfBall.x + golfBall.radius >= obstacle2.x && golfBall.x - golfBall.radius <= obstacle2.x + obstacle2.width &&
        golfBall.y + golfBall.radius >= obstacle2.y && golfBall.y - golfBall.radius <= obstacle2.y + obstacle2.height
        if golfBall.x + golfBall.radius >= obstacle2.x && golfBall.x < obstacle2.x && velocity_x > 0
            velocity_x *= -1
        elsif golfBall.x - golfBall.radius <= obstacle2.x + obstacle2.width && golfBall.x > obstacle2.x + obstacle2.width && velocity_x < 0
            velocity_x *= -1
        elsif golfBall.y + golfBall.radius >= obstacle2.y && golfBall.y < obstacle2.y && velocity_y > 0
            velocity_y *= -1
        elsif golfBall.y - golfBall.radius <= obstacle2.y + obstacle2.height && golfBall.y > obstacle2.y + obstacle2.height && velocity_y < 0
            velocity_y *= -1
        end
    end










    golfBall.x += velocity_x
    golfBall.y += velocity_y

    velocity_x *= friction
    velocity_y *= friction
end


show
