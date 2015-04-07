class GameObject
  attr_accessor :x, :y
  
  def initialize(window, object_pool = nil, x: , y: )
    @window = window
    @x = x
    @y = y
    @components = []
    @named_components = {}
    @object_pool = object_pool
    @object_pool << self
  end

  def add_component(component, name = nil)
    @components << component
    @named_components[name] = component if name
  end

  def component(name)
    @named_components[name]
  end

  def update
    @components.each{|c| c.update}
  end
  
  def draw
    @components.each{|c| c.draw}
  end

  def button_down(id)
    @components.each{|c| c.button_down(id)}
  end

  def button_up(id)
    @components.each{|c| c.button_up(id)}
  end
  
  def removeable?
    @removeable
  end

  def mark_for_removal
    @removeable = true
  end

  protected

  def object_pool
    @object_pool
  end
end
