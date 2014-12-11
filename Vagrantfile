
Vagrant.configure(2) do |config|
  config.vm.define 'queuetest' do |qt|
    qt.vm.box = 'hashicorp/precise64'
    qt.vm.network :private_network, ip: '192.168.50.20'
    qt.vm.provider 'virtualbox' do |vb|
      vb.memory = 1024
    end
    qt.vm.provision 'ansible' do |ansible|
      ansible.playbook = 'provisioning/playbook.yml'
    end
  end
end
