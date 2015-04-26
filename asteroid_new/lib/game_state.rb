class GameState
  attr_reader :scroll_x
  
  def initialize(window, scroll_x: 0)
    @window = window
    @scroll_x = scroll_x
  end

  def update
    # override
  end

  def draw
    # override
  end

  def button_down(id)
    # override
  end

  def button_up(id)
    # override
  end
end

# -----------------------
#  Subclass: Intro State
# -----------------------

class IntroState < GameState  
  def initialize(window)
    super(window)
    @text = GameText.new(@window, alignment: :center, text: 'PRESS SPACE TO BEGIN')
  end

  def draw
    @text.draw
  end

  def button_down(id)
    @window.enter_state(PlayState) if id == Gosu::KbSpace
  end
end

# ----------------------
#  Subclass: Play State
# ----------------------

class PlayState < GameState
  SCROLL_SPEED ||= 5
  
  def initialize(window)
    super(window, scroll_x: SCROLL_SPEED)
    @object_pool = ObjectPool.new
    Ship.new(@window, @object_pool, x: 150, y: 150)
  end

  def update
    @object_pool.update
    random_rock
  end

  def draw
    @object_pool.draw
  end

  def button_down(id)
    @window.enter_state(PausedState) if id == Gosu::KbP
    @window.close if id == Gosu::KbEscape     # Make this go to menu state
    #random_explosion if id == Gosu::KbSpace   # TESTING
    #Missile.new(@window, @object_pool, x: 100, y: 100) if id == Gosu::KbSpace  # TESTING
    @object_pool.button_down(id)
  end

  private
  
  def random_explosion
    Explosion.new(@window, @object_pool, x: rand(0.0..@window.width), y: rand(0.0..@window.height))
  end

  def random_rock
    now = Gosu.milliseconds
    delta = now - (@last_spawn ||= now)
    rock_count = @object_pool.select{|o| o.is_a? Rock}.size
    if delta > 100 && rock_count < rand(5..15)
      #Rock.new(@window, @object_pool, x: @window.width * rand(0.4..0.6), y: @window.height * rand(0.4..0.6), vel_x: 0, vel_y: 0, ang_vel: 1)
      Rock.new(@window, @object_pool, x: @window.width, y: rand(0.0..@window.height), vel_x: rand(-2.0..-1.0), vel_y: rand(-0.5..0.5), ang_vel: rand(-0.5..0.5))
      #Rock.new(@window, @object_pool, x: @window.width, y: @window.height * 0.30 + 70 * Math.sin(now/200), vel_x: -1, vel_y: 0, ang_vel: rand(-0.5..0.5))
      #Rock.new(@window, @object_pool, x: @window.width, y: @window.height * 0.60 - 70 * Math.sin(now/200 + Math::PI), vel_x: -1, vel_y: 0, ang_vel: rand(-0.5..0.5))
      @last_spawn = now
    end
  end
end

# ------------------------
#  Subclass: Paused State
# ------------------------

class PausedState < GameState  
  def initialize(window)
    super(window)
    @text = GameText.new(@window, alignment: :center, text: 'PAUSED - PRESS P OR ESCAPE TO RESUME')
  end

  def draw
    @text.draw
  end

  def button_down(id)
    case id
    when Gosu::KbP, Gosu::KbEscape
      @window.exit_state
    end
  end
end
