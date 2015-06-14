module Asteroid

  class RockGenerator
    
    def initialize(game, rock_info, speed_range, spin_range, target)
      @game = game
      @rock_info = rock_info
      @speed_range = speed_range
      @spin_range = spin_range
      @target = target
    end

    def spawn_rock
      Rock.new(@game, random_pos, random_vel, 0, random_spin, 3, 1, @target)
    end

    private
    
    def random_pos
      [@game.width, @game.height].map{|max| Gosu.random(0, max)}
    end

    def random_vel
      rand_ang = Gosu.random(0, 360)
      rand_speed = Gosu.random(*@speed_range)
      VectorMath.from_scalar_angle(rand_speed, rand_ang)
    end
    
    def random_spin
      rand_spin = Gosu.random(*@spin_range)
    end

  end
end
