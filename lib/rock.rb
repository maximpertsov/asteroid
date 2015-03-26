module Asteroid

  class Rock < Sprite
    include Chasing
    attr_reader :rock_info

    def initialize(game, pos, vel, ang, ang_vel, health = 3, collide_damage = 1, target = nil)
      @rock_info = MediaInfo.new(image_file: YARN_IMAGE, #ROCK_IMAGE,
                                 tile_size: YARN_TILE_SIZE, #ROCK_TILE_SIZE,
                                 radius: YARN_RADIUS, #ROCK_RADIUS,
                                 scale: 0.3)
      super(game, pos, vel, ang, ang_vel, @rock_info, health, collide_damage)
      set_target(target)
    end

    def update
      super
      chase(@target) unless @target.nil?
    end
    
  end

end
