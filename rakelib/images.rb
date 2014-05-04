##########################################################################
# Emoji images
##########################################################################

directory 'tmp/images'
raw_src_images   = FileList['sources/gemoji/images/emoji/unicode/*.png']
EMOJI_SRC_IMAGES = raw_src_images.exclude(/fe0f/) #exclude variant images
resized_files = []
DESIRED_SIZES.each do |px_size|
  directory "tmp/images/#{px_size}"
  sized_pathmap = EMOJI_SRC_IMAGES.pathmap("tmp/images/#{px_size}/%f")
  sized_pathmap.zip(EMOJI_SRC_IMAGES).each do |target, source|
    file target => ["tmp/images/#{px_size}", source] do
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

directory 'build/images'
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

#file lists for each of the end result size groups, for making spritesheets etc
OPTIMIZED_IMAGES_BY_PX = {}
DESIRED_SIZES.each do |px_size|
  OPTIMIZED_IMAGES_BY_PX[px_size] = EMOJI_OPTIMIZED_IMAGES.clone.exclude( /images\/(?!#{px_size})\d\d\// )
end

desc "created sized and optimized images of all individual emoji"
task 'build:images' => EMOJI_OPTIMIZED_IMAGES
