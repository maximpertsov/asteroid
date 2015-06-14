module Asteroid
  
  class MediaInfo
    attr_reader :image_file, :tile_size, :animated, :z, :lifespan, :color, :scale, :sound

    def initialize(image_file: , tile_size: , radius: 0, animated: false, z: 1, lifespan: nil, scale: 1, color: nil, sound: nil)
      @image_file = image_file
      @tile_size = tile_size
      @unscaled_radius = radius
      @animated = animated
      @scale = scale
      @z = z
      set_lifespan(lifespan)
      set_color(color)
      @sound = sound
    end

    def radius
      @scale * @unscaled_radius
    end

    def clone(new_z: z, new_lifespan: lifespan, new_scale: scale, new_color: color, silent: false, new_sound: sound)
      MediaInfo.new(image_file: image_file,
                    tile_size: tile_size,
                    radius: @unscaled_radius,
                    animated: animated,
                    z: new_z,
                    lifespan: new_lifespan,
                    scale: new_scale,
                    color: new_color,
                    sound: silent ? nil : new_sound)
    end

    private
    
    def set_lifespan new_lifespan
      if new_lifespan.nil?
        @lifespan = Float::INFINITY
      else
        @lifespan = new_lifespan
      end
    end

    def set_color new_color
      if new_color.nil?
        @color = Gosu::Color::WHITE
      else
        @color = new_color
      end
    end
    
  end
end
