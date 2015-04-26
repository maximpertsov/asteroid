class GameWindow < Gosu::Window
  WIN_SIZE = [800, 600]
  CAPTION = 'Asteroid'

  def initialize
    super(*WIN_SIZE, false)
    self.caption = CAPTION
    @states = []
    @images = {}
    @sounds = {}
    enter_state(IntroState)
  end

  def update
    current_state.update
  end

  def draw
    current_state.draw
  end

  def button_down(id)
    current_state.button_down(id)
  end

  def button_up(id)
    current_state.button_up(id)
  end
  
  # =====================
  # state management (consider moving to it's own class)

  def has_state?
    !@states.empty?
  end
  
  def enter_state(state)
    current_state.pause if has_state?
    @states << state.new(self)
    current_state.enter
  end

  def exit_state
    @states.pop
    current_state.resume if has_state?
  end

  def current_state
    @states[-1]
  end

  # =====================
  
  def load_image(image_file, tile_size = nil)
    if tile_size
      @images[image_file] ||= Utils.load_tiles(self, image_file, tile_size)
    else
      @images[image_file] ||= Utils.load_image(self, image_file)
    end
  end
end
