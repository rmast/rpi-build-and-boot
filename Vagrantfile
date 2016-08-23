# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty32"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.customize ["modifyvm", :id, "--cpus"  , "4"   ]
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
 # If you want to use this system to netboot Raspberry Pi, then uncomment this line
 config.vm.network "public_network", bridge: 'ask', ip: "192.168.178.250"

#  config.vm.provision "ansible" do |ansible|
#    ansible.playbook = "playbook.yml"
#  end
end
