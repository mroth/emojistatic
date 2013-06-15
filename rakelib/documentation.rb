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

DOC_FILES = FileList[readme_target, index_target]
task 'build:documentation' => DOC_FILES
task 'clobber:documentation' do
  rm DOC_FILES
end
