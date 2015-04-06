class GameObject
  def initialize(window, object_pool = nil)
    @window = window
    @components = []
    @object_pool = object_pool
    @object_pool << self
  end

  def components
    @components
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
