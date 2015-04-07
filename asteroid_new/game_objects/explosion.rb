class Explosion < GameObject
  def initialize(window, object_pool, x: , y:)
    super
    ExplosionSprite.new(@window, self)
    ExplosionSounds.play(@window)
  end
end

class ExplosionSprite < SpriteComponent
  IMAGE ||= 'explosion_alpha.png'
  TILE_SIZE ||= [128, 128]
  FRAME_DELAY ||= 20 #ms
  Z_SCALE = 2

  def initialize(window, game_object, z: 2, image_file: IMAGE, tile_size: TILE_SIZE, frame_delay: FRAME_DELAY)
    super
  end

  private

  def done?
    @done ||= @current_frame >= animation.size
  end
  
  def animation
    @@animation ||= Utils.load_tiles(@window, @image_file, @tile_size)
  end
end

class ExplosionSounds < Component
  SOUND = 'explosion-01.ogg'
  
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
