##########################################################################
# build cache manifests
##########################################################################

CACHE_MANIFESTS = FileList.new
DESIRED_SIZES.each do |px_size|
  target = "build/manifests/emoji-#{px_size}px-images-manifest.appcache"
  containing_directory = target.pathmap("%d")
  source_files = OPTIMIZED_IMAGES_BY_PX[px_size]
  required_files = source_files.clone.add(containing_directory)
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
