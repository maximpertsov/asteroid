require 'set'

module Asteroid

  class SpriteGroup
    
    def initialize(kaboom_info = nil, kaboom_damage = 0, target = nil)
      @sprites = Set.new []
      @kaboom_info = kaboom_info
      @kaboom_damage = kaboom_damage
      @target = target
    end

    def empty?
      @sprites.empty?
    end
    
    def size
      @sprites.size
    end

    def add sprite
      @sprites.add sprite
    end

    def closest_to(other_sprite)
      
    end

    def update
      @sprites.each {|s| s.update}
      explode_if {|s| s.health < 1} 
      @sprites.delete_if {|s| s.expired? || s.health < 1}
      #chase
    end

    def draw
      @sprites.each{|s| s.draw}
    end

    def explodes?
      !@kaboom_info.nil?
    end

    def explode_if
      # takes block and blows up all sprites in group that fit criteria
      if explodes?
        sprites_to_explode = @sprites.select {|s| yield s}
        vel_reduction = 0.9
        @sprites += sprites_to_explode.map do |s|
          s.spawn(s.pos, VectorMath.scalar_mult(s.vel, (1 - vel_reduction)), 0, 0, @kaboom_info, Float::INFINITY, @kaboom_damage)
        end
      end
    end
    
    def collide!(other_sprite)
      @sprites.any? {|s| s.collide! other_sprite}
    end
    
    def group_collide!(other_sprites)
      @sprites.select{|s| other_sprites.collide! s}
    end

    # chasing methods

    # def chase
    #   unless @target.nil?
    #     @sprites.each {|s| s.chase(@target) if s.respond_to? :chase}
    #   end
    # end

    def set_target(target)
      @sprites.each {|s| s.set_target(target) if s.respond_to? :set_target}
    end

    def remove_target
      @sprites.each {|s| s.remove_target if s.respond_to? :remove_target}
    end
    
  end
end
