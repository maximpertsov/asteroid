['lib', 'game_states', 'game_objects'].each {|f| $: << (File.join(File.dirname(__FILE__), f))}

# built-in modules and Gems
require 'gosu'
require 'set'

# main object templates
require 'game_window'
require 'game_state'
require 'game_object'
require 'object_pool'
require 'component'

#entities
require 'background'
require 'game_text'
require 'ship'
require 'explosion'
require 'missile'
require 'rock'

module Utils
  def self.load_tiles(window, image_file, tile_size, tileable=false)
    Gosu::Image.load_tiles(window, Utils.media_path(image_file), *tile_size, tileable)
  end

  def self.load_image(window, image_file)
    [Gosu::Image.new(window, Utils.media_path(image_file))]
  end

  # load Gosu Song object from music file; returns nil if file isn't found
  def self.load_song(song_file)
    file_path = Utils.media_path(song_file)
    Gosu::Song.new(file_path) if File.file? file_path
  end

  def self.draw_point(window, x, y, c, z = 0, sz = 1)
    window.draw_quad(x + sz, y + sz, c, x + sz, y - sz, c, x - sz, y - sz, c, x - sz, y + sz, c, z)
  end

  def self.draw_circle(window, x, y, r, c, z = 0, sz = 1)
    lf,rt,tp,bt = [x-r,x+r,y-r,y+r].map{|n| n.to_i}
    (lf..rt).each do |i|
      (tp..bt).each {|j| draw_point(window, i, j, c, z, sz) if (Gosu.distance(i, j, x, y) - r).abs < sz}
    end
  end
end
  
GameWindow.new.show

