# crosscompiling for RPi on Windows host via NFS

If you want to see your raspberry pi boot from NFS of a virtual Ubuntu machine to be able to try this proposed
cross-compilation-setup most of the automation scripts of the original readme will do. 
 
Install VirtualBox and Vagrant on Windows 10, but don't install ansible as that's not supported in Windows 10.

From within a directory to which you downloaded ´Vagrantfile´ and the rest of this repository start the Ubuntu-virtual machine with 

```sh
vagrant up
```

This will boot a headless virtual-machine on your Windows-10 PC which can be entered by ssh

```sh
vagrant ssh
```

If vagrant can't find ssh then follow the instructions that appear.


Within the ssh-session to the Ubuntu-image you can see the files in the Windows directory of your vagrantfile (in /vagrant):
```sh
ls /vagrant
```

- playbook.yml
- build_cross_gcc.sh
- install_ansible.sh
- 2015-09-24-raspbian-jessie.img (copied back from the Pi after the install_dependencies.sh step)

Remark: The 2015-09-24-raspbian-jessie.img is even too small for an apt-get upgrade, so you will have to grow it soon.
Remark: shutting down this virtual machine makes you loose this /vagrant shared folder permanently, probably due to rights-issues, so do everything what you want with these files in one session.

build a recent ansible-version, reply with a lower-case 'y':
```sh
cd 
. /vagrant/install_ansible.sh
cd /vagrant

```


edit the head of playbook.yml, to contain the local user and files to use, and the sizing if not using 2015-09-24-raspbian-jessie.img:
```sh
---
- hosts: localhost
  remote_user: vagrant
  vars:
    of_version: of_v0.9.3_linuxarmv6l_release
    image: 2015-09-24-raspbian-jessie-after-install_dependencies.img
# ---
```

Then run the playbook:
```sh
sudo ansible-playbook playbook.yml
```

For suspending and resuming the virtual machine in order to restore the /vagrant - shared folder you can use:
- vagrant suspend
- vagrant resume

After you stopped the machine you can restart it with
- vagrant reload

If you get a read/write error mounting /opt/raspberry/root with the way the shared folder is linked you can also copy the raspberry-image to /home/vagrant and at the next bootup (via Virtual Box in order not to link the /vagrant - shared folder) remove this empty /vagrant directory and make your own symlink by

```sh
sudo rmdir /vagrant
sudo ln -s /home/vagrant /vagrant
```

After a while a cron-script will mount /opt/raspberrypi/boot again from the image.

For making the NFS-Pi-image it is sufficient to copy /opt/raspberrypi/boot/cmdline.txt back to the first partition of your SD-card. This will make your Pi mount the image in /vagrant of your virtual machine as root.

Probably after a reboot you can reach your Pi with

```sh
ssh pi@192.168.178.201
```

As the DNS is not working rightaway the internet-settings of the Pi can be updated:
```sh
sudo bash -c 'cat << EOF > /etc/network/interfaces
# Please note that this file is written to be used with dhcpcd.
# For static IP, consult /etc/dhcpcd.conf and man dhcpcd.conf.

auto lo
iface lo inet loopback

 auto eth0
    iface eth0 inet static
        address 192.168.178.201
        netmask 255.255.255.0
        gateway 192.168.178.250
EOF'	
```
followed by
```sh
sudo /etc/init.d/networking restart
```
I used a similar Ubuntu 14.04-install from VMWare with a SD-card mounted as second harddrive, but that should also be possible with VirtualBox. 
You can use sfdisk -d /dev/sdb instead of fdisk -d (image) to show the exact entries as mentioned in the original readme.
