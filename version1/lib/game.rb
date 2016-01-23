module Asteroid
  class Game < Gosu::Window
    attr_reader :running
    attr_accessor :images

    def initialize
      super(*WINDOW_SIZE, false)
      self.caption = WINDOW_TITLE

      @background_image = Gosu::Image.new(self, BACKGROUND_IMAGE, true)
      @score_display = Gosu::Font.new(self, 'Synchro Let', 50)
      @timer_display = Gosu::Font.new(self, 'Synchro Let', 50)
      @result_display = Gosu::Font.new(self, 'Synchro Let', 50)

      # quick and dirty image cache - store images that have already been loaded
      @images = {}

      # sounds
      #@missile_sound = Gosu::Sample.new(self, MISSILE_SOUND)
      @thrust_sound = Gosu::Sample.new(self, THRUST_SOUND)
      @kaboom_sound = Gosu::Sample.new(self, KABOOM_SOUND)

      # base sprites
      @ship_info = MediaInfo.new(image_file: SHIP_IMAGE, tile_size: [90, 90], radius: 35)
      @kaboom_info = MediaInfo.new(image_file: KABOOM_IMAGE, tile_size: [128, 128], radius: 17, animated: true, lifespan: 24, z: 5, sound: @kaboom_sound)

      # different kinds of explosions
      @kabooms = Hash[:standard, @kaboom_info,
                      :small_blue, @kaboom_info.clone(new_scale: 0.25, new_color: Gosu::Color::CYAN, silent: true),
                      :big_red, @kaboom_info.clone(new_z: 2, new_scale: 5, new_color: Gosu::Color::RED),
                      :gas, @kaboom_info.clone(new_z: 2, new_color: Gosu::Color::FUCHSIA)]


      @sprite_groups = Hash[:ships, SpriteGroup.new(@kabooms[:standard]),
                            :missiles, SpriteGroup.new(@kabooms[:big_red], 3),
                            :rocks, SpriteGroup.new(@kabooms[:standard])]

      @rock_speed_range = INIT_ROCK_SPEED_RANGE
      @rock_limit = INIT_ROCK_LIMIT

      spawn_ship

      @rock_generator = RockGenerator.new(self, @rock_info, @rock_speed_range, ROCK_SPIN_RANGE, nil)

      @score = 0
      @timer = 20
      @goal = 3000
      @running = true

    end

    def pause
      @running = !@running
    end

    def update
      if @timer > 0
        if @running
          read_sustained_inputs # buttons that can be held down
          spawn_rocks(@rock_limit, SAFE_RADIUS)
          @sprite_groups.each_value {|s| s.update}
          process_collisions
          @timer -= 0.01
          if @sprite_groups[:ships].empty?
            spawn_ship
          end
        end
      end
    end

    def draw
      @background_image.draw(0, 0, 0)
      draw_messages
      if @timer > 0
        @sprite_groups.each_value {|s| s.draw}
      end
    end

    def button_down(key)
      #Exit game
      if key == Gosu::KbEscape
        close
      end
      #Pause
      if key == Gosu::KbP
        @running = !@running
      end
      if @running
        #Fire (one shot at a time...)
        if key == Gosu::KbSpace
          @sprite_groups[:missiles].add(@ship.fire_missile)
        end
      end
    end

    def read_sustained_inputs
      # These are inputs corresponding to actions that can be performed continuously

      #Turn Left
      if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft
        @ship.turn_left
      end
      #Turn Right
      if button_down? Gosu::KbRight or button_down? Gosu::GpRight
        @ship.turn_right
      end
      #Thrust
      if button_down? Gosu::KbUp or button_down? Gosu::GpButton0
        @ship.thrust_on
      else
        @ship.thrust_off
      end
      #Rapid Fire - disabled for now because it's too awesome
      # if button_down? Gosu::KbSpace
      #   @sprite_groups[:missiles].add(@ship.fire_missile)
      # end
    end

    def process_collisions
      rocks_destroyed = rock_missile_collisions.select {|s| s.health < 1}
      update_score(rocks_destroyed.size * POINTS_PER_ROCK_DESTROYED)
      rock_ship_collisions
    end

    def spawn_rocks(rock_limit, safe_distance)
      if @sprite_groups[:rocks].size < rock_limit
        new_rock = @rock_generator.spawn_rock
        if new_rock.distance(@ship) > safe_distance
          @sprite_groups[:rocks].add new_rock
        end
      end
    end

    def rock_missile_collisions
      @sprite_groups[:rocks].group_collide! @sprite_groups[:missiles]
    end

    def rock_ship_collisions
      @sprite_groups[:rocks].group_collide! @sprite_groups[:ships]
    end

    def update_score points
      unless @score.nil?
        @score += points
      end
    end

    def spawn_ship
      @ship = Ship.new(self, @ship_info, @missile_info, @thrust_sound)
      @ship.warp(PLAYER_SPAWN_POSITION)
      #@sprite_groups[:rocks].set_target @ship
      @sprite_groups[:ships].add @ship
      update_score(DEATH_PENALTY)
    end

    def draw_messages
      if @timer > 0
        @score_display.draw_rel("SCORE: #{@score}  GOAL: #{@goal}", 20, 20, 10, 0, 0, 1, 1, (@score < @goal) ? Gosu::Color::GREEN : Gosu::Color::BLUE)
        @timer_display.draw_rel("TIME: #{@timer.to_i}", self.width - 20, 20, 10, 1, 0, 1, 1, (@timer > 5) ? Gosu::Color::GREEN : Gosu::Color::RED)
      elsif @score >= @goal
        @result_display.draw_rel("SUCCESS!", self.width / 2, self.height / 2, 10, 0.5, 0.5, 1, 1, Gosu::Color::GREEN)
      else
        @result_display.draw_rel("YOU FAILED!", self.width / 2, self.height / 2, 10, 0.5, 0.5, 1, 1, Gosu::Color::GREEN)
      end
    end

  end
end
