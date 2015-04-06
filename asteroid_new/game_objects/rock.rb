class Rock < GameObject
  RADIUS ||= 40
  
  attr_accessor :x, :y, :vel_x, :vel_y, :ang
  attr_reader :ang_vel

  def initialize(window, object_pool, x: , y: , vel_x: , vel_y: , ang_vel:)
    super(window, object_pool) 
    @x, @y = x, y
    @vel_x, @vel_y = vel_x, vel_y
    @ang = 0
    @ang_vel = ang_vel
    @radius = RADIUS
    [RockGraphics, RockPhysics].each{|c| c.new(@window, self)}
  end
end

class RockGraphics < Component
  IMAGE ||= 'asteroid_blue.png'
  TILE_SIZE ||= [90, 90]
  Z_SCALE ||= 1
  
  def initialize(window, game_object)
    super
    @current_frame = 0
    @time_created = Gosu.milliseconds
  end

  def draw
    image = current_frame
    image.draw_rot(x, y, Z_SCALE, object.ang)
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

class RockPhysics < Component  
  def initialize(window, game_object)
    super
  end

  def update
    object.x += object.vel_x
    object.y += object.vel_y
    object.ang += object.ang_vel 
  end
end
