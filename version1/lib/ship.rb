module Asteroid
  
  class Ship < Sprite
    
    def initialize(game, ship_info, missile_info, thrust_sound, safe_spawn_time = 50.0)
      super(game, [0,0], [0,0], 0, 0, ship_info, 1)
      @thrust = false
      @thrust_sound = thrust_sound
      @missile_info = missile_info
      @safe_spawn_time = safe_spawn_time
    end

    def warp pos
      @pos = Array.new pos
    end

    def turn_left
      @ang -= TURN_SPEED
    end

    def turn_right
      @ang += TURN_SPEED
    end

    def fire_missile
      Missile.fire(self, MISSILE_SPEED, 1)
      # cannon_pos = VectorMath.add(@pos, VectorMath.from_scalar_angle(radius, @ang))
      # missile_vel = VectorMath.add(@vel, VectorMath.from_scalar_angle(MISSILE_SPEED, @ang))
      # Missile.new(@game, cannon_pos, missile_vel, @ang, 0, 1, 1)
      #self.spawn(cannon_pos, missile_vel, @ang, 0, @missile_info, 1, 1) 
    end

    def thrust_on
      @thrust = true
      if @thrust_sample.nil? || !@thrust_sample.playing?
        @thrust_sample = @thrust_sound.play(1,1,true)
      end
      accelerate
    end

    def thrust_off
      @thrust = false
      if !@thrust_sample.nil?
        @thrust_sample.stop
        @thrust_sample = nil
      end
    end

    def draw
      unless @age < @safe_spawn_time && @age.to_i.even?
        draw_basic
      end
    end

    def update
      super
      if health < 1 && !@thrust_sample.nil?
        @thrust_sample.stop
        @thrust_sample = nil
      end
    end

    def reduce_health points
      unless @age <  @safe_spawn_time
        super
      end
    end

    def move
      super
      VectorMath.scalar_mult!(@vel, 1 - FRICTION)
    end

    private

    def accelerate
      accel = VectorMath.from_scalar_angle(THRUST_SPEED, @ang)
      @vel = VectorMath.add(@vel, accel)
    end
        
    def draw_basic
      @image_tiles[@thrust ? 1 : 0].draw_rot(*@pos, 1, @ang + IMAGE_ANGLE_OFFSET)
    end

  end
end
