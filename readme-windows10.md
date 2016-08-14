# crosscompiling for RPi on Windows host via NFS

If you want to see your raspberry pi boot from NFS of your virtual Ubuntu machine to be able to try this proposed
cross-compilation-setup most of the automation scripts of the original twobitcircus/rpi-build-and-boot git repository will do: 
 
Install VirtualBox and Vagrant on Windows 10, but don't install ansible as that's not supported in Windows 10.

Start the Ubuntu-virtual machine with 
```sh
> vagrant up
```

from within a directory to which you downloaded ´Vagrantfile´ and the rest of this repository. 

This will boot a headless virtual-machine on your Windows-10 PC which can be entered by ssh

```sh
> vagrant ssh
```

If vagrant can't find ssh then follow the instructions that appear.

Within the ssh-session to the Ubuntu-image you can see the files in the Windows directory of your vagrantfile (in (/home)/vagrant):
```sh
$ ls
```

- playbook.yml
- build_cross_gcc.sh
- install_ansible.sh
- 2015-09-24-raspbian-jessie.img (copied back from the Pi after the install_dependencies.sh step)


build a recent ubuntu-image:
```sh
$ . ./install_ansible.sh
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
Making the NFS-Pi-image is shown in the original how-to.

I used a similar Ubuntu 14.04-install from VMWare with a SD-card mounted as second harddrive, but that should also be possible with VirtualBox. 
You can use sfdisk -d /dev/sdb instead of fdisk -d (image) to show the exact entries as mentioned in the original readme.
