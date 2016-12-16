VAGRANTFILE_API_VERSION = '2'
CENTOS67_BOX_NAME = 'bento/centos-6.7'

UPDATE_HOSTS_FILE = 'shell/update_hosts_file.sh'
INSTALL_SSH_KEYS = 'shell/install_ssh_keys.sh'
INSTALL_RVM_PREREQS = 'shell/install_rvm_prereqs_centos6.sh'
INSTALL_RVM_RUBY_233_NO_DOCS = 'shell/install_ruby_2.3.3_for_vagrant_user.sh'
INSTALL_CAP_2155 = 'shell/install_capistrano_2.15.5_for_vagrant_user.sh'

servers = {
  :captut => {
    :box => CENTOS67_BOX_NAME,
    :cpu => '1',
    :ram => '1024',
    :ip => '10.0.0.101',
    :provision_shells => [
      UPDATE_HOSTS_FILE,
      INSTALL_SSH_KEYS,
      INSTALL_RVM_PREREQS,
      INSTALL_RVM_RUBY_233_NO_DOCS,
      INSTALL_CAP_2155
    ]
  },
  :capalpha => {
    :box => CENTOS67_BOX_NAME,
    :cpu => '1',
    :ram => '1024',
    :ip => '10.0.0.102',
    :provision_shells => [
      UPDATE_HOSTS_FILE,
      INSTALL_SSH_KEYS
    ]
  },
  :capbravo => {
    :box => CENTOS67_BOX_NAME,
    :cpu => '1',
    :ram => '1024',
    :ip => '10.0.0.103',
    :provision_shells => [
      UPDATE_HOSTS_FILE,
      INSTALL_SSH_KEYS
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
