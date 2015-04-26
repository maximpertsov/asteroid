class GameState
  def initialize(window, music: nil)
    @window = window
    @object_pool = ObjectPool.new
    if music
      @music = Utils.load_song(music) and @music.play(true)
    end
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

  def pause
    @music.pause if music?
  end

  def resume
    @music.play if music?
  end

  def music?
    !@music.nil?
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
  MUSIC = "vectorman_day4.mp3"
  
  def initialize(window)
    super(window, music: MUSIC)
    @background = Background.new(@window, @object_pool, vel_x: -SCROLL_SPEED)
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
    if id == Gosu::KbP
      @window.enter_state(PausedState)
    end
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

    random_incoming(delta, rock_count, now)
    #random_middle(delta, rock_count, now)
    #sine_wave(delta, now)
  end

  private
  
  # spawn random rocks towards the player
  def random_incoming(delta, rock_count, now)
    if delta > 100 && rock_count < rand(5..15)
      Rock.new(@window, @object_pool, x: @window.width, y: rand(0.0..@window.height), vel_x: rand(-2.0..-1.0), vel_y: rand(-0.5..0.5), ang_vel: rand(-0.5..0.5))
      @last_spawn = now
    end
  end
  
    # spawn random rocks in the middle of the stage
  def random_middle(delta, rock_count, now)
    if delta > 100 && rock_count < rand(5..15)
      rand_x = @window.width * rand(0.4..0.6)
      rand_y = @window.height * rand(0.4..0.6)
      Rock.new(@window, @object_pool, x: rand_x, y: rand_y, vel_x: 0, vel_y: 0, ang_vel: 1)
      @last_spawn = now
    end 
  end

  # create a sine-wave tunnel of rocks
  def sine_wave(delta, now)    
    if delta > 100
      _y = 0.40         # tunnel width as a percentage of screen height
      _dy = 0.20        # maximum displacement as a percentage of screen height
      _per = 1000.0     # wave oscillation period in milliseconds
      top_y = @window.height * (0.5 * (1 + _y) + _dy * Math.sin(now/_per))
      bot_y = @window.height * (0.5 * (1 - _y) + _dy * Math.sin(now/_per))
      
      Rock.new(@window, @object_pool, x: @window.width, y: top_y, vel_x: -5, vel_y: 0, ang_vel: rand(-0.5..0.5))
      Rock.new(@window, @object_pool, x: @window.width, y: bot_y, vel_x: -5, vel_y: 0, ang_vel: rand(-0.5..0.5))
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
