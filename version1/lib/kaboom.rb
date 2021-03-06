module Asteroid

  class Kaboom < Sprite
    
    def initialize(game, pos, vel, color = nil, silent = false, scale = 1, lifespan = nil, collide_damage = 0)
      basic_info = BasicImageInfo.new(KABOOM_IMAGE, tile_size: [128, 128], radius: 17, animated: true)
      info = ImageInfo.new(kaboom_basic_info, z: 5, scale: scale, lifespan: lifespan, color: color)
      super(game, pos, vel, 0, 0, info, KABOOM_SOUND, Float::INFINITY, collide_damage)
    end
    
  end

end
