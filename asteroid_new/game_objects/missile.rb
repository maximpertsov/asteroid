class Missile < GameObject
  def initialize(window, object_pool, x: , y: , vel_x: , vel_y: )
    super(window, object_pool, x: x, y: y)
    MissileSprite.new(@window, self)
    MotionComponent.new(@window, self, vel_x: vel_x, vel_y: vel_y)
    CollisionComponent.new(@window, self, self.object_pool, radius: 5, enemy_classes: [Rock])
    MissileSounds.play(@window)
  end
end

class MissileSprite < SpriteComponent
  IMAGE ||= 'shot2.png'
  TILE_SIZE ||= [10, 10]
  LIFESPAN = 500 #ms
  
  def initialize(window, game_object, image_file: IMAGE, tile_size: TILE_SIZE)
    super
    @time_created = Gosu.milliseconds
  end
  
  private

  def done?
    @done ||= Gosu.milliseconds - @time_created >= LIFESPAN
  end
  
  def animation
    @@animation ||= Utils.load_tiles(@window, @image_file, @tile_size)
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
