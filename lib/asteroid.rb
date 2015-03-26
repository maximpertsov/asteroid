require 'gosu'
require_relative 'vector_math'
require_relative 'chasing'

require_relative 'media_info'
require_relative 'sprite'
require_relative 'rock'
require_relative 'missile'
require_relative 'ship'
require_relative 'rock_generator'
require_relative 'sprite_group'
require_relative 'game'

module Asteroid  
  # Window and background
  WINDOW_SIZE = [800, 600]
  WINDOW_TITLE = "Asteroid"
  BACKGROUND_IMAGE = "./media/nebula_blue.s2014.png"
  
  # Game constants
  POINTS_PER_ROCK_DESTROYED = 100
  DEATH_PENALTY = -300

  # Ship (player) constants
  PLAYER_SPAWN_POSITION = [320, 240]
  IMAGE_ANGLE_OFFSET = -90
  TURN_SPEED = 4.5
  THRUST_SPEED = 0.5
  FRICTION = 0.05
  SAFE_RADIUS = 200 # rocks will not spawn within this distance from the ship
  
  # Rock constants
  INIT_ROCK_LIMIT = 20 # This will shift up as the game progresses
  INIT_ROCK_SPEED_RANGE = [0.5, 1.0] # This will shift up as the game progresses
  ROCK_SPIN_RANGE = [2, 5]
  # Missile constants
  MISSILE_SPEED = 5
  
  # Image file locations - credit Kim Lathrop for all
  # Ship
  SHIP_IMAGE = "./media/double_ship.png"
  SHIP_TILE_SIZE = [90, 90]
  SHIP_RADIUS = 35
  # Missile
  MISSILE_IMAGE = "./media/shot2.png"
  MISSILE_TILE_SIZE = [10, 10]
  MISSILE_RADIUS = 3
  MISSILE_LIFESPAN = 50 
  # Rock
  ROCK_IMAGE = "./media/asteroid_blue.png"
  ROCK_TILE_SIZE = [90, 90]
  ROCK_RADIUS = 40
  # Yarn??
  YARN_IMAGE = "./media/yarn_ball_256x256.png"
  YARN_TILE_SIZE = [256, 256]
  YARN_RADIUS = 60
  # Explosion
  KABOOM_IMAGE = "./media/explosion_alpha.png"
  KABOOM_TILE_SIZE = [128, 128]
  KABOOM_RADIUS = 17
  KABOOM_LIFESPAN = 24
  
  # Sound file locations
  THRUST_SOUND = "./media/thrusters_launch.ogg" # public domain - SoundBible.com
  MISSILE_SOUND = "./media/laser-02.ogg" # public domain - MediaCollege.com
  KABOOM_SOUND = "./media/explosion-01.ogg" # unverified license - MediaCollege.com

end
