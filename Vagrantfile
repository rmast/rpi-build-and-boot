# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty32"
  config.vm.provider "virtualbox" do |prl|
#    prl.update_guest_tools = true
  end

  # If you want to use this system to netboot Raspberry Pi, then uncomment this line
 config.vm.network "public_network", bridge: 'ask', ip: "10.0.0.1"

#  config.vm.provision "ansible" do |ansible|
#    ansible.playbook = "playbook.yml"
#  end
end
