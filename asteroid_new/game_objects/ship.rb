class Ship < GameObject
  def initialize(window, object_pool, x: , y: )
    super
    [ShipSprite, ShipPhysics, ShipGraphics].map{|c| c.new(@window, self)}
    ShipControls.new(@window, self, self.object_pool)
  end
end

class ShipSprite < SpriteComponent
  Z_SCALE ||= 1
  
  def initialize(window, game_object, z: Z_SCALE)
    super
  end
end

class ShipGraphics < Component
  IMAGE ||= 'double_ship.png'
  TILE_SIZE ||= [90, 90]
  FRAME_DELAY ||= 10 #ms

  def initialize(window, game_object)
    super
    @current_frame = 0
    sprite = game_object.component(:sprite)
    if sprite
      @ang = sprite.ang
      @z = sprite.z
      @color = sprite.color
    else
      raise 'Sprite component missing!'
    end
  end

  def draw
    image = current_frame
    image.draw_rot(self.x, self.y, @z, @ang, 0.5, 0.5, 1, 1, @color)
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

class ShipPhysics < PhysicsComponent
  FRICTION ||= 0.05
  
  def initialize(window, game_object)
    super
  end

  def update
    super
    self.vel_x *= 1 - FRICTION
    self.vel_y *= 1 - FRICTION
  end
end

class ShipControls < Component
  THRUST_SPEED ||= 0.5
  
  def initialize(window, game_object, object_pool)
    super(window, game_object)
    @physics = game_object.component(:physics)
    @object_pool = object_pool
  end

  def update
    if @physics
      @physics.vel_x += THRUST_SPEED if @window.button_down? Gosu::KbRight
      @physics.vel_x -= THRUST_SPEED if @window.button_down? Gosu::KbLeft
      @physics.vel_y += THRUST_SPEED if @window.button_down? Gosu::KbDown
      @physics.vel_y -= THRUST_SPEED if @window.button_down? Gosu::KbUp
    else
      raise 'Physics component missing!'
    end
  end

  def button_down(id)
    if id == Gosu::KbSpace
      m = Missile.new(@window, @object_pool, x: object.x, y: object.y)
      m.physics.x_vel = 10
    end
  end
end
