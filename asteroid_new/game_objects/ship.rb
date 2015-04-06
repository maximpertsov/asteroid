class Ship < GameObject
  attr_accessor :x, :y
  attr_reader :physics

  def initialize(window, object_pool, x: , y: )
    super(window, object_pool)
    @x, @y = x, y
    ShipGraphics.new(@window, self)
    @physics = ShipPhysics.new(@window, self)
    ShipControls.new(@window, self, self.object_pool)
  end
end

class ShipGraphics < Component
  IMAGE ||= 'double_ship.png'
  TILE_SIZE ||= [90, 90]
  FRAME_DELAY ||= 10 #ms

  def initialize(window, game_object)
    super
    @current_frame = 0
  end

  def draw
    image = current_frame
    image.draw_rot(x, y, 2, 0)
  end
  
  def update
    now = Gosu.milliseconds
    delta = now - (@last_frame ||= now)
    if delta > FRAME_DELAY
      @last_frame = now
    end
    @current_frame += (delta / FRAME_DELAY).floor
  end
  
  private
  
  def current_frame
    animation[@current_frame % animation.size]
  end
  
  def animation
    @@animation ||= Gosu::Image.load_tiles(@window, Utils.media_path(IMAGE), *TILE_SIZE, false)
  end
end

class ShipPhysics < Component
  FRICTION ||= 0.05
  
  attr_accessor :x_vel, :y_vel
  
  def initialize(window, game_object, x_vel: 0, y_vel: 0)
    super(window, game_object)
    @x_vel, @y_vel = x_vel, y_vel
  end

  def update
    object.x += self.x_vel
    object.y += self.y_vel
    self.x_vel *= 1 - FRICTION
    self.y_vel *= 1 - FRICTION
  end
end

class ShipControls < Component
  THRUST_SPEED ||= 0.5
  
  attr_accessor :x_vel, :y_vel
  
  def initialize(window, game_object, object_pool)
    super(window, game_object)
    @physics = object.physics
    @object_pool = object_pool
  end

  def update
    @physics.x_vel += THRUST_SPEED if @window.button_down? Gosu::KbRight
    @physics.x_vel -= THRUST_SPEED if @window.button_down? Gosu::KbLeft
    @physics.y_vel += THRUST_SPEED if @window.button_down? Gosu::KbDown
    @physics.y_vel -= THRUST_SPEED if @window.button_down? Gosu::KbUp
  end

  def button_down(id)
    m = Missile.new(@window, @object_pool, x: object.x, y: object.y)
    m.physics.x_vel = 10
  end
end
