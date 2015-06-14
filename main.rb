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
      puts "Please specify a verions:\n'v1' for the old version or 'v2' for the beta new version"
    else
      v = ARGV[0]
      if @versions.key? v
        $: << File.join(File.dirname(__FILE__), @versions[v])
        require "asteroid"
      else  
        puts "'#{v}' is not a valid version"
      end
    end
  end
end

Program.new.run
