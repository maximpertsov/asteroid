class Component
  def initialize(window, game_object = nil, name = nil)
    @window = window
    @name = name
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
  attr_accessor :ang, :z, :color
  
  def initialize(window, game_object, ang: 0, z: 1, color: Gosu::Color::WHITE)
    super(window, game_object, :sprite)
    @ang = ang
    @z = z
    @color = color
  end
end

class GraphicsComponent < Component
  # Finish
end

class PhysicsComponent < Component
  attr_accessor :vel_x, :vel_y
  
  def initialize(window, game_object, vel_x: 0, vel_y: 0)
    super(window, game_object, :physics)
    @vel_x = vel_x
    @vel_y = vel_y
    #@ang_vel = ang_vel
  end

  def update
    object.x += self.vel_x
    object.y += self.vel_y
  end
end
