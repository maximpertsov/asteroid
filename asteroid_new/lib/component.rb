class Component
  def initialize(window, game_object = nil, name = nil)
    @window = window
    @name = name # OPTIONAL: name component so other components can interact with it
    self.object = game_object
  end
  
  def update
    # override
  end
  
  def draw
    # override
  end

  def button_down(id)
    # override
  end

  def button_up(id)
    # override
  end

  protected

  def object=(obj)
    if obj
      @object = obj
      obj.add_component(self, @name)
    end
  end
  
  def x
    @object.x
  end
  
  def y
    @object.y
  end
  
  def object
    @object
  end
end

# -------------------------
# Specific component types
# -------------------------

class SpriteComponent < Component
  attr_accessor :z, :color, :ang, :ang_vel
  
  def initialize(window, game_object, z: 1, color: Gosu::Color::WHITE, ang: 0, ang_vel: 0, image_file: nil, tile_size: nil, frame_delay: 1)
    super(window, game_object, :sprite)
    @ang = ang
    @ang_vel = ang_vel
    @z = z
    @color = color
    @current_frame = 0
    # TODO: considering moving the following fields into an 'ImageInfo' class
    @image_file = image_file
    @tile_size = tile_size
    @frame_delay = frame_delay
  end

  def update
    # update rotation
    self.ang += self.ang_vel
    # update animation frame
    if animation.size > 1
      now = Gosu.milliseconds
      delta = now - (@last_frame ||= now)
      if delta > @frame_delay
        @last_frame = now
      end
      @current_frame += (delta / @frame_delay).floor
    end
    # update removal
    object.mark_for_removal if done?
  end

  def draw
    image = current_frame
    image.draw_rot(self.x, self.y, self.z, self.ang, 0.5, 0.5, 1, 1, self.color)
  end
  
  private
  
  def current_frame
    animation[@current_frame % animation.size]
  end

  def done?
    # override
  end
  
  def animation
    # override
  end
end

class MotionComponent < Component
  attr_accessor :vel_x, :vel_y
  
  def initialize(window, game_object, vel_x: 0, vel_y: 0)
    super(window, game_object, :motion)
    @vel_x = vel_x
    @vel_y = vel_y
  end

  def update
    object.x += self.vel_x
    object.y += self.vel_y
  end
end

class CollisionComponent < Component
  attr_accessor :radius, :health, :damage 

  def initialize(window, game_object, object_pool, radius: , health: Float::INFINITY, damage: 0, enemy_classes: [])
    super(window, game_object, :collision)
    @object_pool = object_pool
    @radius = radius
    @health = health
    @damage = damage
    @enemy_classes = enemy_classes
  end

  def update
    crash_enemies!
    object.mark_for_removal if dead?
  end

  def dead?
    self.health <= 0
  end
  
  def collides? other_obj
    Gosu.distance(object.x, object.y, other_obj.x, other_obj.y) < self.radius + other_obj.component(:collision).radius
  end

  def crash! other_obj
    if (other_obj != object) && (self.collides? other_obj)
      other_obj.component(:collision).health -= self.damage
    end
  end

  def crash_enemies!
    @object_pool.each do |o|
      if @enemy_classes.any? {|e| o.instance_of? e}
        self.crash! o
      end
    end
  end
end
