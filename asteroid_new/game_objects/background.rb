class Background < GameObject
  def initialize(window, object_pool, x: 0, y: 0, vel_x: 0, vel_y: 0)
    super(window, object_pool, x: x, y: y)
    BackgroundSprite.new(@window, self)
    MotionComponent.new(@window, self, vel_x: vel_x, vel_y: vel_y)
  end
end

class BackgroundSprite < SpriteComponent
  IMAGE ||= 'nebula_blue.s2014.png'
  Z_SCALE ||= 0

  def initialize(window, game_object, z: Z_SCALE, image_file: IMAGE)
    super
  end

  def update
    super
    object.x = object.x % (@window.width * 2)
  end

  def draw
    image = current_frame
    image.draw(self.x - @window.width, self.y, self.z)
  end
  
end
