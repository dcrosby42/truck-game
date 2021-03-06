APP_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")

def add_to_loadpath(dir)
  $LOAD_PATH << dir
end

add_to_loadpath( APP_ROOT + "/lib" )

#
# Platform-specific loadpath setup for Gosu, Chipmunk, FMOD, etc
# 
# binlib = APP_ROOT + "/binlib"
# case RUBY_PLATFORM
# when /win32/
#   add_to_loadpath( binlib + "/win32" )
# when /darwin/
#   add_to_loadpath( binlib + "/osx_intel" )
# end

#
# Ruby gems loadpath setup
#
gems_dir = APP_ROOT + "/vendor/gems"
Dir["#{gems_dir}/*"].each do |gemdir|
  add_to_loadpath( gemdir + "/lib" )
end

#
# Everybody loves these:
#
require 'gosu'
require 'constructor'
require 'publisher'

require 'z_order'
require 'base_mode'
require 'gosu_char_id_map'

require 'array_ext'
require 'chipmunk_numeric_ext'
require 'chipmunk_vec2_ext'
require 'debug_drawing'

require 'initializer'

require 'polygon'
require 'rectangle'
require 'circle'

DEBUG_SERVER_PORT = 51515


if ENV['TRUCK_DEBUG'] == "on"
  puts "Enabling ruby-debug..."
  require 'rubygems'
  begin
    require 'ruby-debug'
    Debugger.start
  rescue LoadError
    def debugger
      puts "(!! DEBUGGER NOT AVAILABLE !!)"
    end
  end
  puts "ruby-debug enabled."
end
