# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :application, "daytrip"
set :repo_url, "git@github.com:DayTripArm/DayTrip.git"

set :user_name, "deploy"

set :deploy_to, "/home/#{fetch(:user_name)}/daytrip_app"
set :daytrip_home_path, "/home/#{fetch(:user_name)}/"

before "deploy:migrate", "deploy:create_db"

namespace :deploy do

  desc 'Rake db:create'
  task :create_db do
    on roles(:app) do
      within release_path do
        with rails_env: "#{fetch(:stage)}" do
          execute :rake, "db:create"
        end
      end
    end
  end

  desc 'Rake db:seed'
  task :run_seed do
    on roles(:app) do
      within release_path do
        with rails_env: "#{fetch(:stage)}" do
          execute :rake, "db:seed"
        end
      end
    end
  end


  desc 'Rake import:country_cities'
  task :run_cities_import do
    on roles(:app) do
      within release_path do
        with rails_env: "#{fetch(:stage)}" do
          execute :rake, "import:country_cities"
        end
      end
    end
  end


  desc 'Delete DayTrip UI'
  task :delete_daytrip_ui do
    on roles(:app) do
      within release_path do
        with rails_env: "#{fetch(:stage)}" do
          puts "\n******************************Deleting DayTrip-UI***************************************\n"

          execute "cd #{fetch(:daytrip_home_path)}"
          execute "rm -rf DayTripUI"
        end
      end
    end
  end


  desc 'Install DayTrip UI'
  task :install_daytrip_ui do
    on roles(:app) do
      within release_path do
        with rails_env: "#{fetch(:stage)}" do
          puts "\n******************************Install DayTrip UI***************************************\n"

          execute "cd #{fetch(:daytrip_home_path)} && git clone --branch day_trip_new_design git@github.com:DayTripArm/DayTripUI.git"
          execute "cd #{fetch(:daytrip_home_path)}DayTripUI && npm install && npm run build"
        end
      end
    end
  end


end


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true


append :linked_files, "config/database.yml", "config/secrets.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

set :passenger_restart_with_touch, true

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
