##########################################################################
# build documentation for hosted version
##########################################################################
SOURCE_CONTENT = "templates/index.md"
SOURCE_FRONTMATTER = "templates/front_matter.yml"
INDEX_TARGET = "build/index.md"
README_TARGET = "build/README.md"
file INDEX_TARGET => [SOURCE_CONTENT, SOURCE_FRONTMATTER] do
  sh "cat #{SOURCE_FRONTMATTER} #{SOURCE_CONTENT} > #{INDEX_TARGET}"
end
file README_TARGET => SOURCE_CONTENT do
  cp SOURCE_CONTENT, README_TARGET
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

DOC_FILES = FileList[README_TARGET, INDEX_TARGET, JEKYLL_BUILD_FILES]
task 'build:documentation' => DOC_FILES
task 'clobber:documentation' do
  rm DOC_FILES
end
