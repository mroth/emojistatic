##########################################################################
# build documentation for hosted version
##########################################################################
source = "templates/index.md"
target = "build/index.md"
file target => source do
  cp source, target
end

task 'build:documentation' => target
task 'clobber:documentation' do
  rm target
end