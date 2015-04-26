class Ship < GameObject
  def initialize(window, object_pool, x: , y: )
    super
    [ShipSprite, ShipMotion].map{|c| c.new(@window, self)}
    CollisionComponent.new(@window, self, self.object_pool, radius: 25, enemy_classes: [Rock], debug_mode: true, explodes: true)
    ShipShooting.new(@window, self, self.object_pool)
  end
end

class ShipSprite < SpriteComponent
  IMAGE ||= 'double_ship.png'
  TILE_SIZE ||= [90, 90]
  FRAME_DELAY ||= 10
  
  def initialize(window, game_object, image_file: IMAGE, tile_size: TILE_SIZE, frame_delay: FRAME_DELAY)
    super
  end
end

class ShipMotion < MotionComponent
  FRICTION ||= 0.05
  THRUST_SPEED ||= 0.5
  
  def initialize(window, game_object)
    super
  end

  def update
    super
    self.vel_x *= 1 - FRICTION
    self.vel_y *= 1 - FRICTION
    # player_input
    self.vel_x += THRUST_SPEED if @window.button_down? Gosu::KbRight
    self.vel_x -= THRUST_SPEED if @window.button_down? Gosu::KbLeft
    self.vel_y += THRUST_SPEED if @window.button_down? Gosu::KbDown
    self.vel_y -= THRUST_SPEED if @window.button_down? Gosu::KbUp
  end
end

class ShipShooting < Component
  MISSILE_SPEED ||= 10
  
  def initialize(window, game_object, object_pool)
    super(window, game_object)
    @object_pool = object_pool
  end

  def button_down(id)
    if id == Gosu::KbSpace
      Missile.new(@window, @object_pool, x: self.x, y: self.y, vel_x: MISSILE_SPEED, vel_y: 0)
    end
  end
end
