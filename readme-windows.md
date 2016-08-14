If you want to see your raspberry pi boot from NFS of your virtual Ubuntu machine to be able to try this proposed
cross-compilation-setup, which was originally developed for a OsX-host-system, most of the automation scripts of the original twobitcircus/rpi-build-and-boot git repository will do: 
 
Install VirtualBox and Vagrant on Windows 10, but don't install ansible as that's not supported in Windows 10.
Start the Ubuntu-virtual machine with ´vagrant up´ from within a directory with a ´Vagrantfile´ from which most lines are commented out:
	# -*- mode: ruby -*-
	# vi: set ft=ruby :
	Vagrant.configure(2) do |config|
	  config.vm.box = "ubuntu/trusty32"
	  config.vm.provider "virtualbox" do |prl|
	  end
	  # If you want to use this system to netboot Raspberry Pi, then uncomment this line
	 config.vm.network "public_network", bridge: 'ask', ip: "10.0.0.1"
	end

This will boot a headless virtual-machine on your Windows-10 PC which can be entered by ssh

Enter the Vagrant virtual machine following the ssh-instructions that appear when you type
vagrant ssh

build a recent version of ansible within the Ubuntu-image:

sudo apt-get install python-dev libffi-dev libssl-dev git python-pip
sudo pip install https://pypi.python.org/packages/3.4/s/setuptools/setuptools-11.3.1-py2.py3-none-any.whl
git clone https://github.com/ansible/ansible.git
cd ansible/
git checkout  v2.1.1.0-1
git submodule update --init --recursive
sudo make
sudo make install
cd ..

Make sure the ansible file will be processed locally:

sudo mkdir /etc/ansible

sudo bash -c 'cat << EOF > /etc/ansible/hosts
localhost ansible_connection=local
EOF'	

upload your files to (/home)/vagrant from the original git-repository:
playbook.yml
build_cross_gcc.sh

and also 2015-09-24-raspbian-jessie-after-install_dependencies.img

The file 2015-09-24-raspbian-jessie-after-install_dependencies.img is the resulting Pi-image of the install_dependencies.sh step in the original how-to.

edit the head of playbook.yml, to contain the local user and files to use, and the sizing if not using 2015-09-24-raspbian-jessie:
---
- hosts: localhost
  remote_user: vagrant
  vars:
    of_version: of_v0.9.3_linuxarmv6l_release
    image: 2015-09-24-raspbian-jessie-na-install_dependencies.img
# ---

Then run the playbook:
sudo ansible-playbook playbook.yml

Making the NFS-Pi-image is shown in the original how-to.

I used a similar Ubuntu 14.04-install from VMWare with a SD-card mounted as second harddrive, but that should also be possible with VirtualBox. 
You can use sfdisk -d /dev/sdb instead of fdisk -d (image) to show the exact entries as mentioned in the original readme. 