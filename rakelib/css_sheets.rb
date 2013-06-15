##########################################################################
# build embedded css sheets with data-uri
##########################################################################

CSS_SHEETS = FileList.new
DESIRED_SIZES.each do |px_size|
  target = "build/css-sheets/emoji-#{px_size}px.css"
  containing_directory = target.pathmap("%d")
  source_files = OPTIMIZED_IMAGES_BY_PX[px_size]
  required_files = source_files.clone.add(containing_directory)
  source_files_dir = source_files.first.pathmap("%d")

  directory containing_directory
  file target => required_files do
    puts "Generating css-sheet at #{target}"
    squirter = CSSquirt::ImageFileList.new source_files
    doc = squirter.to_css('emoji',true)

    File.open(target,'w') do |f|
      f.write( doc )
    end
  end
  CSS_SHEETS.add(target)
end

MIN_CSS_SHEETS = CSS_SHEETS.pathmap('%d/%n.min%x')
MIN_CSS_SHEETS.zip(CSS_SHEETS).each do |target, source|
  minify(target,source)
end

GZIP_CSS_SHEETS = MIN_CSS_SHEETS.pathmap('%d/%f.gz')
GZIP_CSS_SHEETS.zip(MIN_CSS_SHEETS).each do |target, source|
  gzipify(target,source)
end

desc "build css sheets for emoji images"
task 'build:css_sheets' => GZIP_CSS_SHEETS
