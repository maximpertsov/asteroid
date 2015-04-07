class Missile < GameObject
  attr_reader :physics

  def initialize(window, object_pool, x: , y: )
    super
    @physics = MissilePhysics.new(@window, self)
    MissileGraphics.new(@window, self)
    MissileSounds.play(@window)
  end
end

class MissileGraphics < Component
  IMAGE ||= 'shot2.png'
  TILE_SIZE ||= [10, 10]
  LIFESPAN = 500 #ms
  Z_SCALE ||= 1
  
  def initialize(window, game_object)
    super
    @current_frame = 0
    @time_created = Gosu.milliseconds
  end

  def update
    object.mark_for_removal if done?
  end

  def draw
    image = current_frame
    image.draw_rot(x, y, Z_SCALE, 0)
  end
  
  private
  
  def current_frame
    animation[@current_frame % animation.size]
  end

  def done?
    @done ||= Gosu.milliseconds - @time_created >= LIFESPAN
  end
  
  def animation
    @@animation ||= Gosu::Image.load_tiles(@window, Utils.media_path(IMAGE), *TILE_SIZE, false)
  end
end

class MissilePhysics < Component  
  attr_accessor :x_vel, :y_vel
  
  def initialize(window, game_object, x_vel: 0, y_vel: 0)
    super(window, game_object)
    @x_vel, @y_vel = x_vel, y_vel
  end

  def update
    object.x += self.x_vel
    object.y += self.y_vel
  end
end

class MissileSounds < Component
  SOUND ||= 'laser-02.ogg'
  
  class << self
    def play(window)
      sound(window).play
    end
    
    private
    
    def sound(window)
      @@sound ||= Gosu::Sample.new(window, Utils.media_path(SOUND))
    end
  end
end
