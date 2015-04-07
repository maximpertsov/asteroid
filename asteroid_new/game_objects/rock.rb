class Rock < GameObject
  RADIUS ||= 40
  
  attr_accessor :ang
  attr_reader :ang_vel

  def initialize(window, object_pool, x: , y: , vel_x: , vel_y: , ang_vel:)
    super(window, object_pool, x: x, y: y)
    @ang = 0
    @ang_vel = ang_vel
    @radius = RADIUS
    RockPhysics.new(@window, self, vel_x: vel_x, vel_y: vel_y)
    RockGraphics.new(@window, self)
  end
end

class RockSprite < SpriteComponent
  def initialize(window, game_object)
    super
  end
end

class RockGraphics < Component
  IMAGE ||= 'yarn_ball_256x256.png' #'asteroid_blue.png'
  TILE_SIZE ||= [256, 256] # [90, 90]
  Z_SCALE ||= 1
  
  def initialize(window, game_object)
    super
    @current_frame = 0
    @time_created = Gosu.milliseconds
  end

  def draw
    image = current_frame
    image.draw_rot(x, y, Z_SCALE, object.ang, 0.5, 0.5, 0.25, 0.25)
  end
  
  def update
    object.mark_for_removal if done?
  end
  
  private
  
  def current_frame
    animation[@current_frame % animation.size]
  end

  def done?
    @done ||= object.x < -10 # object goes off left edge of screen
  end
  
  def animation
    @@animation ||= Gosu::Image.load_tiles(@window, Utils.media_path(IMAGE), *TILE_SIZE, false)
  end
end

class RockPhysics < PhysicsComponent  
  def initialize(window, game_object, vel_x: , vel_y: )
    super
  end

  def update
    super
    object.ang += object.ang_vel 
  end
end
