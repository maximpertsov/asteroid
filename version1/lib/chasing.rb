module Asteroid

  module Chasing

    def chase(target)
      speed = 1
      @vel = VectorMath.from_scalar_angle(speed, Gosu.angle(*@pos, *target.pos))
    end

    def chase_if_close(target, max_distance)
      chase(target) if Gosu.distance(*@pos, target.pos) <= max_distance
    end

    def set_target(target)
      @target = target
    end

    def remove_target
      @target = nil
    end
    
  end

end
