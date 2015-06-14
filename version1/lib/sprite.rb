module Asteroid
  
  class Sprite
    attr_reader :game, :pos, :vel, :ang, :ang_vel, :radius, :health, :collide_damage

    def initialize(game, pos, vel, ang, ang_vel, media_info, health = 1, collide_damage = 1)
      @game = game
      @bounds = Array.new [@game.width, @game.height]
      @pos = Array.new pos
      @vel = Array.new vel
      @ang = ang
      @ang_vel = ang_vel
      load_image_info(media_info)
      @age = 0.0
      play_sample(media_info)
      @health = health
      @collide_damage = collide_damage
    end

    def update
      @age = ((@age + 1) % (@num_tiles * 100000)) # reset age to zero for long-running games
      rotate
      move
      remove_sample
    end

    def draw
      tile_idx = @animated ? (@age % @num_tiles) : 0
      @image_tiles[tile_idx].draw_rot(*@pos, @z, @ang, 0.5, 0.5, @scale, @scale, @color)
    end

    def remove_sample
      if !@sample.nil? && !@sample.playing?
        @sample.stop
        @sample = nil
      end
    end
    
    def rotate
      @ang += @ang_vel 
    end

    def move
      @pos.each_index {|i| @pos[i] = (@pos[i] + @vel[i]) % @bounds[i]}
    end

    def expired?
      @age > @lifespan
    end

    def spawn(pos = @pos, vel = [0,0], ang = 0, ang_vel = 0, media_info = nil, health = 1, collide_damage = 0)
      Sprite.new(@game, pos, vel, ang, ang_vel, media_info, health, collide_damage)
    end
    
    def distance sprite
      Gosu::distance(*@pos, *sprite.pos)
    end

    def collide? sprite
      distance(sprite) < @radius + sprite.radius
    end
    
    def reduce_health points
      @health = [0, @health - points].max
    end

    def collide! other_sprite
      if (collide? other_sprite)
        self.reduce_health(other_sprite.collide_damage)
        other_sprite.reduce_health(self.collide_damage)
        true
      else
        false
      end
    end

    private
    
    def load_image_info media_info
      @tile_size = media_info.tile_size
      load_image(media_info)
      @num_tiles = @image_tiles.size
      @radius = media_info.radius
      @scale = media_info.scale
      @color = media_info.color
      @lifespan = media_info.lifespan
      @animated = media_info.animated
      @z = media_info.z
    end

    # retrieve image from cache or load image
    def load_image(media_info)
      img_file = media_info.image_file
      @game.images[img_file] ||= Gosu::Image.load_tiles(@game, img_file, *@tile_size, false)
      @image_tiles = @game.images[img_file]
    end

    def play_sample media_info
      sound = media_info.sound
      unless sound.nil?
        @sample = sound.play
      end
    end
      
  end
end
