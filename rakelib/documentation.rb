##########################################################################
# build documentation for hosted version
##########################################################################
source_content = "templates/index.md"
index_target = "build/index.md"
readme_target = "build/README.md"
file index_target => source_content do
  cp source_content, index_target
end
file readme_target => source_content do
  cp source_content, readme_target
end

JEKYLL_SOURCE_FILES = FileList['templates/_layouts/*']
JEKYLL_BUILD_FILES = JEKYLL_SOURCE_FILES.pathmap("%{templates,build}p")
JEKYLL_BUILD_FILES.zip(JEKYLL_SOURCE_FILES).each do |target, source|
  containing_directory = target.pathmap("%d")

  directory containing_directory
  file target => [containing_directory, source] do
    cp source,target
  end
end

DOC_FILES = FileList[readme_target, index_target, JEKYLL_BUILD_FILES]
task 'build:documentation' => DOC_FILES
task 'clobber:documentation' do
  rm DOC_FILES
end
