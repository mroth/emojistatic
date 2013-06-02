task :stage  => ['ghpages:stage']
task :deploy => ['ghpages:deploy']

config_file = File.read('config.yml')
PAGES_REPO = YAML.load(config_file)['deploy']['ghpages_repo']
PAGES_BRANCH = YAML.load(config_file)['deploy']['ghpages_branch']

namespace :ghpages do
  DEPLOY_DIR = "deploy"

  desc "set up a deploy directory for github pages deploy strategy"
  task :setup do
    unless File.directory? DEPLOY_DIR
      mkdir_p DEPLOY_DIR
      cd DEPLOY_DIR do
        sh "git clone -b #{PAGES_BRANCH} #{PAGES_REPO} ."
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
    head = `git log --pretty="%h" -n1`.strip
    cd DEPLOY_DIR do
      sh "git add ."
      sh "git commit -am 'update files to #{head}'"
      sh "git push"
    end
  end

  task :not_dirty do
    #idea stolen from https://github.com/neo/git_immersion/blob/master/Rakefile
    cd DEPLOY_DIR do
      fail "Deploy directory not clean!" if /nothing to commit/ !~ `git status`
    end
  end

  task :echo_config do
    puts "repo: #{PAGES_REPO}"
    puts "branch: #{PAGES_BRANCH}"
  end
end
