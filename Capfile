# Configuration
set :user, 'vagrant'

# Servers
server "capalpha", :all, :agroup
server "capbravo", :all, :bgroup

# Tasks
namespace :simple do
  desc "Default action: hostname and current user"
  task :default do
    # display_hostname
    # display_current_user
    run_test_deploy_on_agroup
    run_test_deploy_on_all
    run_test_cleanup_on_all
  end

  desc "Display hostname"
  task :display_hostname, :roles => [ :all ] do
    run "uname -n"
  end

  desc "Display current user"
  task :display_current_user, :roles => [ :agroup ] do
    run "whoami"
  end

  desc "Run Test Deploy on agroup"
  task :run_test_deploy_on_agroup, :roles => [ :agroup ] do
    run "#{sudo} /bin/bash /vagrant/bin/test_deploy.sh"
  end

  desc "Run Test Deploy on all"
  task :run_test_deploy_on_all, :roles => [ :all ] do
    run "#{sudo} /bin/bash /vagrant/bin/test_deploy.sh"
  end

  desc "Run Test Cleanup on all"
  task :run_test_cleanup_on_all, :roles => [ :all ] do
    run "#{sudo} /bin/bash /vagrant/bin/test_cleanup.sh"
  end
end
