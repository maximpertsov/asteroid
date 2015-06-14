#!/usr/bin/env ruby

module Utils
  def self.media_path(file)
    File.join(File.dirname(__FILE__), 'media', file)
  end
end

class Program
  def initialize
    @versions = {"v1" => "version1",
                 "v2" => "version2"}
  end

  def run
    if ARGV.empty?
      puts "poop"
    else
      v = ARGV[0]
      if @versions.key? v
        $: << File.join(File.dirname(__FILE__), @versions[v])
        require "asteroid"
      else  
        puts "still poop"
      end
    end
  end
end

Program.new.run
