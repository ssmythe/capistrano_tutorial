VAGRANTFILE_API_VERSION = '2'
CENTOS69_BOX_NAME = 'bento/centos-6.9'

DOS2UNIX_SHELL_SCRIPTS = 'shell/dos2unix_shell_scripts_skipping.sh' unless (ENV['OS'] == 'Windows_NT')
DOS2UNIX_SHELL_SCRIPTS = 'shell/dos2unix_shell_scripts.sh' if (ENV['OS'] == 'Windows_NT')
UPDATE_HOSTS_FILE = 'shell/update_hosts_file.sh'
INSTALL_SSH_KEYS = 'shell/install_ssh_keys.sh'
INSTALL_RVM_PREREQS = 'shell/install_rvm_prereqs_centos6.sh'
INSTALL_RVM_RUBY_187_NO_DOCS = 'shell/install_ruby_1.8.7_for_vagrant_user.sh'
INSTALL_CAP_260 = 'shell/install_capistrano_2.6.0_for_vagrant_user.sh'
INSTALL_RVM_RUBY_233_NO_DOCS = 'shell/install_ruby_2.3.3_for_vagrant_user.sh'
INSTALL_CAP_2155 = 'shell/install_capistrano_2.15.5_for_vagrant_user.sh'
INSTALL_PERL = 'shell/install_perl.sh'
COPY_GEMFILE187 = 'shell/copy_gemfile_ruby187_to_gemfile.sh'
COPY_GEMFILE233 = 'shell/copy_gemfile_ruby233_to_gemfile.sh'
ACCEPT_KNOWN_HOSTS = 'shell/accept_known_hosts_for_vagrant.sh'

servers = {
  :capalpha => {
    :box => CENTOS69_BOX_NAME,
    :cpu => '1',
    :ram => '1024',
    :ip => '10.0.0.102',
    :provision_shells => [
      UPDATE_HOSTS_FILE,
      INSTALL_PERL,
      INSTALL_SSH_KEYS
    ]
  },
  :capbravo => {
    :box => CENTOS69_BOX_NAME,
    :cpu => '1',
    :ram => '1024',
    :ip => '10.0.0.103',
    :provision_shells => [
      UPDATE_HOSTS_FILE,
      INSTALL_PERL,
      INSTALL_SSH_KEYS
    ]
  },
  :captut => {
    :box => CENTOS69_BOX_NAME,
    :cpu => '1',
    :ram => '1024',
    :ip => '10.0.0.101',
    :provision_shells => [
      DOS2UNIX_SHELL_SCRIPTS,
      UPDATE_HOSTS_FILE,
      INSTALL_SSH_KEYS,
      INSTALL_RVM_PREREQS,
      INSTALL_RVM_RUBY_187_NO_DOCS,
      COPY_GEMFILE187,
      INSTALL_CAP_260,
      INSTALL_PERL,
      ACCEPT_KNOWN_HOSTS
    ]
  },
  :captut233 => {
    :box => CENTOS69_BOX_NAME,
    :cpu => '1',
    :ram => '1024',
    :ip => '10.0.0.104',
    :provision_shells => [
      DOS2UNIX_SHELL_SCRIPTS,
      UPDATE_HOSTS_FILE,
      INSTALL_SSH_KEYS,
      INSTALL_RVM_PREREQS,
      INSTALL_RVM_RUBY_233_NO_DOCS,
      COPY_GEMFILE233,
      INSTALL_CAP_2155,
      INSTALL_PERL,
      ACCEPT_KNOWN_HOSTS
    ]
  }
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  servers.each_pair do |name, spec|
    box_url, box, cpu, ram, ip, provision_shells = spec[:box_url], spec[:box], spec[:cpu], spec[:ram], spec[:ip], spec[:provision_shells]
    config.vm.define name do |node|
      node.vm.box_url = box_url
      node.vm.box = box
      node.vm.hostname = name
      node.vm.network 'private_network', ip: ip
      node.vm.provider 'virtualbox' do |v|
        v.cpus = cpu
        v.memory = ram
      end
      provision_shells.each do |provision_shell|
        node.vm.provision 'shell', path: "#{provision_shell}"
      end
    end
  end
end
