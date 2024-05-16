require 'ruby2d' # IMPORTERAR RUBY2D BIBLIOTEKET

# Sätter upp fönstret för spelet
set title: 'Golf' # TITEL
set width: 1024 # BREDD I PIXLAR
set height: 768 # HÖJD I PIXLAR
set background: 'green' # BAKGRUNDSFÄRG

# Klass för golfbollen
class Ball
  attr_accessor :x, :y, :velocity, :angle, :radius, :yv, :xv # ATTRIBUTER

  # Initierar en ny boll
  def initialize(x_init, y_init, radius)
    @x = x_init
    @y = y_init
    @xv = 0 # x-hastighet
    @yv = 0 # y-hastighet
    @velocity = 0 # Hastighet
    @angle = 0 # Vinkel
    @radius = radius # Radie
    @shape = Circle.new( # Skapar en cirkel för att representera bollen
      x: @x,
      y: @y,
      radius: radius,
      color: 'white'
    )
  end

  # Skjuter bollen med en viss hastighet och vinkel
  def shoot
    @xv = @velocity * Math.cos(@angle)
    @yv = @velocity * Math.sin(@angle)
  end

  # Flyttar bollen och hanterar kollisioner med kanterna
  def move
    @x += @xv
    @y += @yv

    @shape.x = @x
    @shape.y = @y
    @xv *= 0.95 # Minskar hastigheten (friktion)
    @yv *= 0.95

    if hit_bottom? || hit_top? # Kollision med topp och botten
      @yv = -@yv
    end
    if hit_left? || hit_right? # Kollision med vänster och höger
      @xv = -@xv
    end
  end

  # Kontrollfunktioner för kollision med kanterna
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

  # Kontrollera kollision med hinder och justera hastigheten vid kollision
  def hit_obstacle?(obstacle)
    if @x + @radius > obstacle.x && @x - @radius < obstacle.x + obstacle.rectangle.width &&
       @y + @radius > obstacle.y && @y - @radius < obstacle.y + obstacle.rectangle.height

      if (@x - @radius < obstacle.x && @xv > 0) || (@x + @radius > obstacle.x + obstacle.rectangle.width && @xv < 0)
        @xv = -@xv # Ändra x-hastighet vid kollision med vänster eller höger sida av hindret
      end

      if (@y - @radius < obstacle.y && @yv > 0) || (@y + @radius > obstacle.y + obstacle.rectangle.height && @yv < 0)
        @yv = -@yv # Ändra y-hastighet vid kollision med topp eller botten av hindret
      end
    end
  end
end

# Klass för hinder
class Obstacle
  attr_accessor :x, :y, :rectangle

  def initialize(x_init, y_init)
    @x = x_init
    @y = y_init
    @rectangle = Rectangle.new(x: @x, y: @y, height: 350, width: 90, color: 'red') # Skapar en rektangel för hindret
  end
end

# Klass för hål
class Hole
  attr_accessor :x, :y, :radius

  def initialize(x_init, y_init, radius)
    @x = x_init
    @y = y_init
    @radius = radius
    @goal = Circle.new(x: @x, y: @y, radius: @radius, color: 'black') # Skapar en cirkel för hålet
  end

  def update
    @goal.x = @x
    @goal.y = @y
  end
end

# Variabler för att hantera spelets tillstånd
$game_state = :playing
$you_win_text = nil
$play_again_button = nil

# Funktion för att starta spelet
def playing
  $game_state = :playing

  $golfball.x = rand(100..300) # Sätter random startposition för bollen
  $golfball.y = rand(100..600)

  $hole.x = rand(600..700) # Sätter random position för hålet
  $hole.y = rand(200..700)
  $hole.update

  $rectangle = Obstacle.new(400, 200) # Skapar ett hinder

  $stroke_counter = 0 # Nollställer slagräknaren
  $stroke_text.text = "Strokes: #{$stroke_counter}" # Uppdaterar slagtexten

  $you_win_text.remove if $you_win_text # Tar bort "DU VANN" text om den finns
  $play_again_button.remove if $play_again_button # Tar bort knappen om den finns
  $play_again_text.remove if $play_again_text
end

# Funktion för att visa vinstskärmen
def show_win_screen
  $game_state = :won

  $you_win_text = Text.new(
    'DU VANN', # Skapar text för vinstmeddelande
    x: (Window.width / 2) - 100,
    y: (Window.height / 2) - 50,
    size: 50,
    color: 'yellow'
  )

  $play_again_button = Rectangle.new(
    x: (Window.width / 2) - 100,
    y: (Window.height / 2) + 30,
    width: 200,
    height: 50,
    color: 'blue'
  )

  $play_again_text = Text.new(
    'Spela igen', # Skapar text för knappen
    x: (Window.width / 2) - 60,
    y: (Window.height / 2) + 40,
    size: 20,
    color: 'white'
  )
end

# Skapar en ny boll, hål och hinder
$golfball = Ball.new(rand(100..300), rand(100..600), 25)
$hole = Hole.new(rand(600..700), rand(200..700), 40)
$rectangle = Obstacle.new(400, 200)

# Skapar en text för att visa antalet slag
$stroke_counter = 0
$stroke_text = Text.new("Strokes: #{$stroke_counter}", x: 10, y: 10, size: 20, color: 'white')

# Variabler för att hålla muskoordinater
xd = 0
yd = 0
xu = 0
yu = 0

# Hanterar musnedtryckning
on :mouse_down do |event|
  if $game_state == :playing
    xd = event.x
    yd = event.y
  elsif $game_state == :won
    # Kontrollera om knappen "Spela igen" trycks
    if event.x >= $play_again_button.x && event.x <= $play_again_button.x + $play_again_button.width &&
       event.y >= $play_again_button.y && event.y <= $play_again_button.y + $play_again_button.height
      playing
    end
  end
end

# Hanterar knappsläpp (space för att starta om spelet)
on :key_up do |event|
  if event.key == 'space' && $game_state == :playing
    playing
  end
end

# Hanterar mussläppning
on :mouse_up do |event|
  if $game_state == :playing
    xu = event.x
    yu = event.y

    # Beräknar bollens hastighet och vinkel baserat på musdragning
    $golfball.velocity = Math.sqrt((xu - xd)**2 + (yu - yd)**2) * 0.1
    $golfball.angle = Math.atan2(yu - yd, xu - xd) + Math::PI
    $golfball.shoot

    $stroke_counter += 1 # Ökar slagräknaren med 1
    $stroke_text.text = "Strokes: #{$stroke_counter}" # Uppdaterar slagtexten

  end
end

# Uppdaterar spelet kontinuerligt
update do
  if $game_state == :playing
    $golfball.move

    # Kontrollera om bollen är i hålet
    if $hole.radius > Math.sqrt(($hole.x - $golfball.x)**2 + ($hole.y - $golfball.y)**2)
      show_win_screen # Visa vinstskärmen
    end

    # Kontrollera kollision med hinder
    $golfball.hit_obstacle?($rectangle)
  end
end

playing # Startar spelet

show # Visar spelet
