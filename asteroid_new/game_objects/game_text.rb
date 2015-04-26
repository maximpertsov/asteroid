class GameText < GameObject
  FONT ||= 'synchro_let.ttf'
  DEFAULT_COLOR ||= Gosu::Color::GREEN
  DEFAULT_SIZE ||= 50
  Z_SCALE ||= 10

  attr_accessor :text

  def initialize(window, object_pool, alignment: :center, text: '', color: DEFAULT_COLOR)
    super(window, object_pool, x: 0, y: 0)  # x and y will be reset by set_text_pos method
    @color = color
    @font = Gosu::Font.new(@window, Utils.media_path(FONT), DEFAULT_SIZE)
    set_text_pos(alignment)
    @text = text
  end

  def draw
    @font.draw_rel(@text, @x, @y, Z_SCALE, @rel_x, @rel_y, 1, 1, @color)
    draw_text_box
  end

  private

  def draw_text_box
    x1, x2 = @x - @font.text_width(@text) * @rel_x, @x + @font.text_width(@text) * (1 - @rel_x) # assume x_factor = 1
    y1, y2 = @y - @font.height * @rel_y, @y + @font.height * (1 - @rel_y)
    # vertices (variable names correspond to 'top-left', 'bottom-left', etc)
    tl, bl, tr, br = [x1, x2].product [y1, y2] 
    draw_order = [tl, bl, br, tr]
    draw_order.zip(draw_order.rotate).map{|v1, v2| @window.draw_line(*v1, @color, *v2, @color, Z_SCALE)}
  end
  
  def set_text_pos(alignment)
    case alignment
    when :center
      rx, ry = 0.5, 0.5
    when :bottom_right
      rx, ry = 0.95, 0.95
    else
      raise 'Invalid alignment'
    end
    @x, @rel_x = @window.width * rx, rx
    @y, @rel_y = @window.height * ry, ry
  end
end
