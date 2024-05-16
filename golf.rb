require 'ruby2d' #IMPORTERAR RUBY2D BIBLIOTEKET

set title: 'Golf' # TITEL
set width: 1024 # BREDD I PIXLAR
set height: 768 # HÖJD I PIXLAR
set background: 'green' # BAKGRUNDS FÄRG


class Ball
  attr_accessor :x , :y, :velocity, :angle, :radius, :yv, :xv #ATTRIBUTER

  # INITIERAR EN NY BOLL
  def initialize(x_init, y_init, radius)
    @x = x_init
    @y = y_init
    @xv = 0 # HASTIGHET I X-LED
    @yv = 0 # HASTIGHET I Y-LED
    @velocity = 0 # START-HASTIGHET
    @angle = 0 # START-VINKEL
    @radius = radius # BOLLENS RADIE
    @shape = Circle.new( # HUR BOLLEN KOMMER SE UT OCH VAR DEN STARTAR
      x: @x,
      y: @y,
      radius: radius,
      color: 'white'
    )
  end

  # SKJUTER BOLLEN MED EN VISS HASTIGHET OCH VINKEL
  def shoot
    @xv = @velocity*Math.cos(@angle)
    @yv = @velocity*Math.sin(@angle)
  end

  # FÖRFLYTTAR BOLLEN OCH HANTERAR KOLLISIONER MED KANTER
  def move
    @x = @x + @xv # @velocity*Math.cos(@angle)
    @y = @y + @yv  #@velocity*Math.sin(@angle)

    @shape.x = @x
    @shape.y = @y
    @xv *= 0.95 # MINSKAR HASTIGHET I X-LED (FRIKTION)
    @yv *= 0.95 # MINSKAR HASTIGHET I Y-LED (FRIKTION)


    if hit_bottom? || hit_top? # VAD SOM HÄNDER NÄR BOLLEN NUDDAR BOTTEN ELLER TOPPEN
      @yv = -@yv
    end
    if hit_left? || hit_right? # VAD SOM HÄNDER NÄR BOLLEN TRÄFFAR HÖGER ELLER VÄNSTER KANT
      @xv = -@xv
    end

  end

  # KONTROLLFUNKTIONER FÖR KOLLISIONER MED KANTERNA
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

   # KONTROLLERAR KOLLISIONEN MED HINDER OCH JUSTERAR HASTIGHETEN VID KOLLISION
  def hit_obstacle?(obstacle)
    if @x + @radius > obstacle.x && @x - @radius < obstacle.x + obstacle.rectangle.width &&
       @y + @radius > obstacle.y && @y - @radius < obstacle.y + obstacle.rectangle.height

      if (@x - @radius < obstacle.x && @xv > 0) || (@x + @radius > obstacle.x + obstacle.rectangle.width && @xv < 0)
        @xv = -@xv # ÄNDRAR X-HASTIGHETEN VID KOLLISION MED VÄNSTER ELLER HÖGER SIDA AV HINDRET
      end

      if (@y - @radius < obstacle.y && @yv > 0) || (@y + @radius > obstacle.y + obstacle.rectangle.height && @yv < 0)
        @yv = -@yv # ÄNDRAR Y-HASTIGHET VID KOLLISION MED TOPP ELLER BOTTEN AV HINDRET
      end
    end
  end
end

# KLASS FÖR HINDER
class Obstacle
  attr_accessor :x, :y, :x1, :x2, :x3, :x4, :y1, :y2, :y3, :y4, :rectangle
  def initialize(x_init, y_init)
    @x = x_init
    @y = y_init
    @rectangle = Rectangle.new(x: @x, y: @y, height: 350, width: 90, color: 'red')
  end
end

# KLASS FÖR HÅL
class Hole
  attr_accessor :x , :y, :radius

  def initialize(x_init, y_init, radius)
    @x = x_init
    @y = y_init
    @radius = radius
    @goal = Circle.new(x: @x, y: @y, radius: @radius, color: 'black')
  end

  def update
    @goal.x = @x
    @goal.y = @y
  end
end

# VARIABLER SOM HANTERAR SPELETS TILLSTÅND
$game_state = :playing
$you_win_text = nil
$play_again_button = nil

# FUNKTION FÖR ATT STARTA SPELET
def playing
  $game_state = :playing

  # SÄTTER RANDOM START-POSITION PÅ BOLLEN
  $golfball.x = rand(100..300)
  $golfball.y = rand(100..600)

  $golfball.yv = 0
  $golfball.xv = 0
  $golfball.velocity = 0

  # SÄTTER RANDOM POSITION PÅ HÅLET
  $hole.x = rand(600..700)
  $hole.y = rand(200..700)
  $hole.update

  $rectangle = Obstacle.new(400, 200) # SKAPAR HINDRET

  $stroke_counter = 0 # NOLLSTÄLLER SLAGRÄKNARE
  $stroke_text.text = "Strokes: #{$stroke_counter}" # Uppdaterar slagtexten

  $you_win_text.remove if $you_win_text # TAR BORT "DU VANN" TEXT
  $play_again_button.remove if $play_again_button # TAR BORT KNAPPEN
  $play_again_text.remove if $play_again_text # TAR BORT TEXTEN
end

# FUNKTION FÖR VINSTSKÄRMEN
def show_win_screen
  $game_state = :won

  $you_win_text = Text.new(
    'DU VANN', # SKAPAR VINSTMEDDELANDE
    x: (Window.width / 2) - 100,
    y: (Window.height / 2) - 50,
    size: 50,
    style: 'bold',
    color: 'white'
  )

  $play_again_button = Rectangle.new(
    x: (Window.width / 2) - 100,
    y: (Window.height / 2) + 30,
    width: 225,
    height: 70,
    color: 'blue'
  )

  $play_again_text = Text.new(
    'Spela igen', # TEXT FÖR KNAPPEN
    x: (Window.width / 2) - 60,
    y: (Window.height / 2) + 40,
    size: 30,
    style: 'cursive',
    color: 'white'
  )
end

# SKAPAR EN NY BOLL, HÅL OCH HINDER
$golfball = Ball.new(rand(100..300),rand(100..600),25)
$hole = Hole.new(rand(600..700),rand(200..700), 40)
$rectangle = Obstacle.new(400, 200)

$stroke_counter = 0
$stroke_text = Text.new("Strokes: #{$stroke_counter}", x: 20, y: 20, size: 40, color: 'white')

# VARIABLER FÖR ATT HÅLLA MUSKOORDINATER
xd = 0
yd = 0
xu = 0
yu = 0

# HANTERAR NÄR MAN TRYCKER NER MUSEN
on :mouse_down do |event|
  if $game_state == :playing
    xd = event.x
    yd = event.y

  elsif $game_state == :won
    # KONTROLLERAR OM KNAPPEN "Spela igen" TRYCKS
    if event.x >= $play_again_button.x && event.x <= $play_again_button.x + $play_again_button.width &&
       event.y >= $play_again_button.y && event.y <= $play_again_button.y + $play_again_button.height
      playing
    end
  end
end

# STARTAR OM SPELET MED SPACE
on :key_up do |event|
  if event.key == 'space' && $game_state == :playing
    playing
  end
end

# HANTERAR NÄR MAN SLÄPPER MUSEN
on :mouse_up do |event|
  if $game_state == :playing
    xu = event.x
    yu = event.y

    # BERÄKNAR BOLLENS HASTIGHET OCH VINKEL BEROENDE PÅ MUSDRAGNING
    $golfball.velocity = Math.sqrt((xu - xd)**2 + (yu - yd)**2) * 0.1
    $golfball.angle = Math.atan2(yu - yd, xu - xd) + Math::PI
    $golfball.shoot

    $stroke_counter += 1 # ÖKAR SLAGRÄKNARE MED 1
    $stroke_text.text = "Strokes: #{$stroke_counter}" # UPPDATERAR SLAG-TEXTEN

  end
end

# UPPDATERAR SPELET HELA TIDEN
update do
  if $game_state == :playing
    $golfball.move

  #KONTROLLERAR OM BOLLEN ÄR I HÅLET
  #OM HALVA BOLLEN ÄR I VINNER MAN
  if $hole.radius > Math.sqrt(($hole.x - $golfball.x)**2 + ($hole.y - $golfball.y)**2)
    show_win_screen

    # playing() # KOMMENTERAD KOD FÖR ATT STARTA OM SPELET
  end

  # KOLLISIONSDETEKTION MED HINDER
  $golfball.hit_obstacle?($rectangle)


end
end


show # VISAR SPELET









# GAMMAL KOD SOM JAG INTE VILL TA BORT
# def playing()

#   # SÄTTER RANDOM START-POSITION FÖR BOLLEN
#   $golfball.x = rand(100..300)
#   $golfball.y = rand(100..600)

#   # SÄTTER RANDOM POSITION FÖR HÅLET
#   $hole.x = rand(600..700)
#   $hole.y = rand(200..700)
#   $hole.update

#   $rectangle = Obstacle.new(400, 200) # SKAPAR HINDRET

#   xd = 0
#   yd = 0
#   xu = 0
#   yu = 0

#   $stroke_counter = 0
#   $stroke_text.text = "Strokes: #{$stroke_counter}"

#   $you_win_text.remove if $you_win_text
# end
