Rake::FileUtilsExt.verbose(true)
require 'bundler'
require 'rake/clean'
Bundler.require(:build)

directory 'build/images/emoji'
EMOJI_IMAGES = FileList['sources/gemoji/images/emoji/unicode/*.png']
OPTIMIZED_EMOJI_IMAGES = EMOJI_IMAGES.pathmap('build/images/emoji/%n%x')
CLOBBER.include('build/images/emoji')

OPTIMIZED_EMOJI_IMAGES.zip(EMOJI_IMAGES).each do |target, source|
  file target => ['build/images/emoji', source] do
    cp source, target

    io = ImageOptim.new(:pngout => false)
    size_before =  File.size(target)
    io.optimize_image!(target)
    size_after = File.size(target)
    size_diff = size_before - size_after
    puts "optimized #{target} with savings of #{size_diff} bytes."
  end
end

task :optimize_images => OPTIMIZED_EMOJI_IMAGES
task :default => :optimize_images


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