class ObjectPool
  def initialize
    @objects = Set.new
    @new_objects = Set.new   # holds newly created objects which then get transferred to the main object pool
  end

  def update
    @objects += @new_objects
    @objects.delete_if {|o| o.removeable?}
    @objects.each{|o| o.update}
  end

  def draw
    @objects.each{|o| o.draw}
  end

  def button_down(id)
    @objects.each{|o| o.button_down(id)}
  end

  def button_up(id)
    @objects.each{|o| o.button_up(id)}
  end

  def <<(obj)
    @new_objects << obj
  end

  def select
    @objects.select
  end
end
