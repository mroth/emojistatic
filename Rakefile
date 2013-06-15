# Rake::FileUtilsExt.verbose(true)
require 'bundler'
require 'rake/clean'
require 'yaml'
require 'erb'
require_relative 'lib/emojistatic'
Bundler.require(:build)

##########################################################################
# Configuration
##########################################################################
DESIRED_SIZES = [64,32,24,20,16]

config_file = File.read('config.yml')
HOST = YAML.load(config_file)["host"]

##########################################################################
# Some helper methods
##########################################################################
def minify(target, source)
  file target => source do
    File.open(target,'w') do |f|
      puts "Minifying #{source} to #{target}"
      f.write( CSSMin.minify(File.read(source)) )
    end
  end
end

def gzipify(target, source)
  file target => source do
    sh "gzip -c #{source} > #{target}"
  end
end

##########################################################################
# Emoji images
##########################################################################
require_relative 'rakelib/images'

##########################################################################
# build embedded css sheets with data-uri
##########################################################################
require_relative 'rakelib/css_sheets'

##########################################################################
# build cache manifests
##########################################################################
require_relative 'rakelib/cache_manifests'

##########################################################################
# build emoji font family css
##########################################################################
require_relative 'rakelib/emojifont'

##########################################################################
# master task list
##########################################################################
CLOBBER.include('build/*')

namespace :build do
  task :default => :all
  desc "build everything (default)"
  task :all => [:images, :cache_manifests, :css_sheets, :emojifont]
end
task :default => :build

#TODO: deal with the below for real
directory 'build/libs/js-emoji'
JSEMOJI_SRC = FileList['sources/js-emoji/emoji.{css,js}']
JSEMOJI_DST = JSEMOJI_SRC.pathmap('build/libs/js-emoji/%f')
# JSEMOJI_MIN = JSEMOJI_DST.pathmap('%X.min%x'')
CLOBBER.include('build/libs/js-emoji')
