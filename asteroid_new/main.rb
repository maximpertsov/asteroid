$: << File.dirname(__FILE__)
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
require 'ship'
require 'explosion'
require 'missile'
require 'rock'

module Utils
  def self.media_path(file)
    File.join(File.dirname(__FILE__), 'media', file)
  end
end
  
GameWindow.new.show

