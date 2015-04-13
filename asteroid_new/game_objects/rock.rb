class Rock < GameObject
  def initialize(window, object_pool, x: , y: , vel_x: , vel_y: , ang_vel:)
    super(window, object_pool, x: x, y: y)
    RockSprite.new(@window, self, ang_vel: ang_vel)
    MotionComponent.new(@window, self, vel_x: vel_x, vel_y: vel_y)
    CollisionComponent.new(@window, self, self.object_pool, radius: 40, max_collisions: 3, enemy_classes: [Missile], debug_mode: true)
  end
end

class RockSprite < SpriteComponent
  IMAGE ||= 'asteroid_blue.png' # 'yarn_ball_256x256.png'
  TILE_SIZE ||= [90, 90] # [256, 256]
  
  def initialize(window, game_object, ang_vel: 0, image_file: IMAGE, tile_size: TILE_SIZE)
    super
  end

  # temporarily over-writing method until I implement a generic way to scale objects
  def draw
    image = current_frame
    image.draw_rot(self.x, self.y, self.z, self.ang, 0.5, 0.5, 1, 1, self.color)
  end

  private
  
  def done?
    @done ||= object.x < -10 # object goes off left edge of screen
  end
  
  def animation
    @@animation ||= Utils.load_tiles(@window, @image_file, @tile_size)
  end
end
