class Explosion < GameObject
  def initialize(window, object_pool, x: , y:)
    super
    ExplosionGraphics.new(@window, self)
    ExplosionSounds.play(@window)
  end
end

class ExplosionGraphics < Component
  IMAGE ||= 'explosion_alpha.png'
  TILE_SIZE ||= [128, 128]
  FRAME_DELAY ||= 20 #ms

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
    object.mark_for_removal if done?
  end
  
  private
  
  def current_frame
    animation[@current_frame % animation.size]
  end
  
  def done?
    @done ||= @current_frame >= animation.size
  end
  
  def animation
    @@animation ||= Gosu::Image.load_tiles(@window, Utils.media_path(IMAGE), *TILE_SIZE, false)
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
