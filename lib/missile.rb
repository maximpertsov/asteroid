module Asteroid
  
  class Missile < Sprite
    attr_reader :missile_info
    
    def initialize(game, pos, vel, ang, ang_vel = 0, health = 1, collide_damage = 1)
      @missile_info = MediaInfo.new(image_file: MISSILE_IMAGE,
                                    tile_size: MISSILE_TILE_SIZE,
                                    radius: MISSILE_RADIUS,
                                    lifespan: MISSILE_LIFESPAN,
                                    sound: Gosu::Sample.new(game, MISSILE_SOUND))
      super(game, pos, vel, ang, ang_vel, @missile_info, health, collide_damage)
    end

    def self.fire(other_sprite, speed, collide_damage = 1)
      # define missile properties
      missile_ang = other_sprite.ang
      missile_vel = VectorMath.add(other_sprite.vel, VectorMath.from_scalar_angle(speed, missile_ang))
      cannon_pos = VectorMath.add(other_sprite.pos, VectorMath.from_scalar_angle(other_sprite.radius, missile_ang))
      # create new missile
      Missile.new(other_sprite.game, cannon_pos, missile_vel, missile_ang, 0, 1, collide_damage)
    end
    
  end

end
