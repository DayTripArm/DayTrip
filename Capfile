# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require 'capistrano/rails'
require 'capistrano/passenger'
require 'capistrano/rails/db'
require "capistrano/rvm"
require "sshkit/sudo"

set :rvm_type, :user
set :rvm_ruby_version, '2.5.7p206'


# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
