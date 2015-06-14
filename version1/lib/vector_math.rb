module Asteroid
  module VectorMath

    def self.add(v1, v2)
      v1.zip(v2).map {|c1,c2| c1 + c2}
    end
    
    def self.scalar_mult(v, s)
      v.map {|c| s * c}
    end

    def self.scalar_mult!(v, s)
      v.map! {|c| s * c}
    end

    def self.from_scalar_angle(s, theta)
      [Gosu.offset_x(theta, s), Gosu.offset_y(theta, s)]
    end
    
  end
end
