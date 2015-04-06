class Component
  def initialize(window, game_object = nil)
    @window = window
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
      obj.components << self
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
