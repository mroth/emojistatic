# Rake::FileUtilsExt.verbose(true)
require 'bundler'
require 'rake/clean'
require 'yaml'
require_relative 'lib/emojistatic'
Bundler.require(:build)

##########################################################################
# Configuration
##########################################################################
DESIRED_SIZES = [64,32,24,16]

config_file = File.read('config.yml')
HOST = YAML.load(config_file)["host"]


##########################################################################
# Emoji images
##########################################################################
directory 'tmp/images/emoji'
EMOJI_SRC_IMAGES = FileList['sources/gemoji/images/emoji/unicode/*.png']
resized_files = []
DESIRED_SIZES.each do |px_size|
  directory "tmp/images/emoji/#{px_size}"
  sized_pathmap = EMOJI_SRC_IMAGES.pathmap("tmp/images/emoji/#{px_size}/%f")
  sized_pathmap.zip(EMOJI_SRC_IMAGES).each do |target, source|
    file target => ["tmp/images/emoji/#{px_size}", source] do
      #just copy image if 64px dont resize
      if px_size == 64
        cp source, target
      else
        puts "resizing (#{px_size}x#{px_size}) #{source} to #{target}"
        image = MiniMagick::Image.open(source)
        image.resize "#{px_size}x#{px_size}"
        image.write target
      end
    end
  end
  resized_files << sized_pathmap
end

# build a file list of the resulting resized images, for mapping and clean
EMOJI_SIZED_IMAGES = resized_files.inject(:+)
CLEAN.include(EMOJI_SIZED_IMAGES)

directory 'build/images/emoji'
EMOJI_OPTIMIZED_IMAGES = EMOJI_SIZED_IMAGES.pathmap("%{tmp,build}p")
EMOJI_OPTIMIZED_IMAGES.zip(EMOJI_SIZED_IMAGES).each do |target, source|
  containing_directory = target.pathmap("%d")

  directory containing_directory
  file target => [containing_directory, source] do
    cp source, target
    io = ImageOptim.new(:pngout => false)
    size_before =  File.size(target)
    io.optimize_image!(target)
    size_after = File.size(target)
    size_diff = size_before - size_after
    puts "optimizing image at #{target} - saved #{size_diff} bytes."
  end
end
# CLOBBER.include(EMOJI_OPTIMIZED_IMAGES)

#file lists for each of the end result size groups, for making spritesheets etc
OPTIMIZED_IMAGES_BY_PX = {}
DESIRED_SIZES.each do |px_size|
  OPTIMIZED_IMAGES_BY_PX[px_size] = EMOJI_OPTIMIZED_IMAGES.clone.exclude( /emoji\/(?!#{px_size})\d\d\// )
end

# build cache manifests
CACHE_MANIFESTS = FileList.new
DESIRED_SIZES.each do |px_size|
  target = "build/manifests/emoji-#{px_size}px-images-manifest.appcache"
  containing_directory = target.pathmap("%d")
  source_files = OPTIMIZED_IMAGES_BY_PX[px_size]
  required_files = source_files.add(containing_directory)
  source_files_dir = source_files.first.pathmap("%d")

  directory containing_directory
  file target => required_files do
    puts "Generating cache manifest at #{target}"
    manifesto_cache = Manifesto.cache :directory => source_files_dir, :timestamp => false
    cleaned_cache = Emojistatic.prefix_manifest( manifesto_cache, HOST + "/images/emoji/#{px_size}" )

    File.open(target, 'w') do |f|
      f.write( cleaned_cache )
    end
  end
  CACHE_MANIFESTS.add(target)
end



desc "resize copies of images to tmp directory for processing"
task :resize_images => EMOJI_SIZED_IMAGES
desc "created sized and optimized images of all individual emoji"
task :optimize_images => EMOJI_OPTIMIZED_IMAGES
desc "build cache manifests for emoji images"
task :cache_manifests => CACHE_MANIFESTS

task :build => [:optimize_images, :cache_manifests]
task :default => :build

directory 'build/libs/js-emoji'
JSEMOJI_SRC = FileList['sources/js-emoji/emoji.{css,js}']
JSEMOJI_DST = JSEMOJI_SRC.pathmap('build/libs/js-emoji/%f')
# JSEMOJI_MIN = JSEMOJI_DST.pathmap('%X.min%x'')
CLOBBER.include('build/libs/js-emoji')


# namespace :assets do
#   namespace :images do
#     task :default => :all
#     task :all => [:copy, :optimize]

#     task :copy_to_tmp do
#       src = "sources/gemoji/images/emoji"
#       dst = "tmp/images/emoji"
#       FileUtils.cp_r src, dst  unless File.directory? dst
#     end
#     task :optimize => :copy_to_tmp do

#     end
#     task :copy_to_build do
#     end
#   end
#   task :spritesheets do
#   end
#   namespace :css_embedded_images do
#   end
# end

# namespace :libraries do
#   namespace :jsemoji do
#   end
# end

task :stage  => ['ghpages:stage']
task :deploy => ['ghpages:deploy']

namespace :ghpages do
  DEPLOY_DIR = "deploy"

  desc "set up a deploy directory for github pages deploy strategy"
  task :setup do
    $pages_repo = 'git@github.com:mroth/emojistatic.git'
    $pages_branch = 'gh-pages'
    unless File.directory? DEPLOY_DIR
      mkdir_p DEPLOY_DIR
      cd DEPLOY_DIR do
        sh "git clone -b #{$pages_branch} #{$pages_repo} ."
      end
    end
  end
  desc "set up a FRESH deploy directory, clobbering whatever exists already"
  task :force_setup => [:clobber, :setup]
  desc "clobber the deploy directory"
  task :clobber do
    rm_r DEPLOY_DIR
  end

  desc "just stage the files, but dont actually push"
  task :stage do
    # remove all existing files, and copy over something clean from build directory
    # this way we'll pick up deleted files as well
    rm_r FileList["#{DEPLOY_DIR}/*"]
    cp_r FileList['build/*'], DEPLOY_DIR
  end
  desc "stage then deploy the files to production"
  task :deploy => [:stage] do
    cd DEPLOY_DIR do
      sh "git add ."
      sh "git commit -am 'updating files from master'"
      sh "git push"
    end
  end

  task :not_dirty do
    #idea stolen from https://github.com/neo/git_immersion/blob/master/Rakefile
    cd DEPLOY_DIR do
      fail "Deploy directory not clean!" if /nothing to commit/ !~ `git status`
    end
  end
end