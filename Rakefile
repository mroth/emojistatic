# Rake::FileUtilsExt.verbose(true)
require 'bundler'
require 'rake/clean'
Bundler.require(:build)

directory 'tmp/images/emoji'
EMOJI_SRC_IMAGES = FileList['sources/gemoji/images/emoji/unicode/*.png']
# PX64_EMOJI_IMAGES = EMOJI_IMAGES.pathmap('build/images/emoji/64/%f')
resized_files = []
[64,32,24,16].each do |px_size|
  directory "tmp/images/emoji/#{px_size}"
  sized_pathmap = EMOJI_SRC_IMAGES.pathmap("tmp/images/emoji/#{px_size}/%f")
  sized_pathmap.zip(EMOJI_SRC_IMAGES).each do |target, source|
    file target => ["tmp/images/emoji/#{px_size}", source] do
      #TODO just copy image if 64px dont resize!
      puts "resizing image for #{target}"
      image = MiniMagick::Image.open(source)
      image.resize "#{px_size}x#{px_size}"
      image.write target
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
  #TODO: less ghetto way to obtain current px_size
  gpx_size = target.match(/\/(\d\d)\//).captures[0]
  directory "build/images/emoji/#{gpx_size}"
  file target => ["build/images/emoji/#{gpx_size}", source] do
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



# directory 'build/images/emoji'
# EMOJI_IMAGES = FileList['sources/gemoji/images/emoji/unicode/*.png']
# OPTIMIZED_EMOJI_IMAGES = EMOJI_IMAGES.pathmap('build/images/emoji/%n%x')
# CLOBBER.include('build/images/emoji')

# OPTIMIZED_EMOJI_IMAGES.zip(EMOJI_IMAGES).each do |target, source|
#   file target => ['build/images/emoji', source] do
#     cp source, target

#     io = ImageOptim.new(:pngout => false)
#     size_before =  File.size(target)
#     io.optimize_image!(target)
#     size_after = File.size(target)
#     size_diff = size_before - size_after
#     puts "optimized #{target} with savings of #{size_diff} bytes."
#   end
# end

task :resize_images => EMOJI_SIZED_IMAGES
task :optimize_images => EMOJI_OPTIMIZED_IMAGES
# task :default => :optimize_images

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