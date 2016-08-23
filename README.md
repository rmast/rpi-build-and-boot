# crosscompiling for RPi on Windows host via NFS

I was interested in seeing my raspberry pi boot from NFS of a virtual Ubuntu machine on Windows to be able to cross compile, like proposed for OsX<sup id="a1">[1](#f1)</sup>

To be able to enable this scenario for Windows I had to take some hurdles, as
- Ansible is not supported in Windows 10
- On my DHCP-hosted LAN the 192.168.* - IP - range is better equipped for connecting to the internet than 10.0.*.
- The /vagrant shared folder gives File I/O errors when hosted from windows

So this is how I did it: 

First install VirtualBox and Vagrant on Windows 10, but don't install ansible as that's not supported in Windows 10.

From within a directory to which you downloaded ´Vagrantfile<sup id="a2">[2](#f2)</sup>´ and the rest of this repository start the Ubuntu-virtual machine with 



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
- 2016-05-27-raspbian-jessie-lite.img

build a recent ansible-version, reply with a lower-case 'y':
```sh
cd 
. /vagrant/install_ansible.sh
cd /vagrant

```


edit the head of playbook.yml, to contain the local user and files to use, and the start of the root and boot-partitions as a result of sfdisk -d 2016-05-27-raspbian-jessie-lite.img, from which you take 512 * the start sector:
```sh
---
- hosts: localhost
  remote_user: vagrant
  vars:
    image: 2016-05-27-raspbian-jessie-lite.img
    offset_boot: 4194304
    offset_root: 70254592
# ---
```

Then run the playbook:
```sh
sudo ansible-playbook playbook.yml
```

This image is already to small for an apt-get update/upgrade, so you'll probably need adding some gigabytes to the image:

```sh
sudo dd if=/dev/zero bs=10MiB of=/home/vagrant/2016-05-27-raspbian-jessie-lite.img conv=notrunc oflag=append count=100
```
You can resize the partition with
```sh
sudo fdisk 2016-05-27-raspbian-jessie-lite.img
```
then delete and recreate the second Linux-partition with the same start-sector.

With resize2fs /dev/loopX (loopX = the mounted root filesystem) you can do an online resize of the filesystem.

For suspending and resuming the virtual machine in order to restore the /vagrant - shared folder you can use:
- vagrant suspend
- vagrant resume

After you stopped the machine you can restart it with
- vagrant reload

If you get many file errors during usage of the image mounted from the shared /vagrant - folder at /opt/raspberry/root (I do) you can also copy the raspberry-image to /home/vagrant and at the next bootup (poweroff and restart via Virtual Box in order not to link the /vagrant - shared folder) remove this empty /vagrant directory and make your own symlink by

```sh
sudo rmdir /vagrant
sudo ln -s /home/vagrant /vagrant
```

After a while a cron-script (/etc/cron.d/opt_raspberrypi_root) will mount /opt/raspberrypi/boot again from the image.

For making the NFS-Pi-image it is sufficient to copy /opt/raspberrypi/boot/cmdline.txt back to the first partition of your SD-card. This will make your Pi mount the image in /vagrant of your virtual machine as root.

Probably after a reboot you can reach your Pi with

```sh
ssh pi@192.168.178.201
```

Next:
- [Setting up distcc](setting-up-distcc.md)

----------------------------------------------

<b id="f1">1</b>
- https://github.com/twobitcircus/rpi-build-and-boot/blob/master/README.md
- https://github.com/chilcano/vagrant-rpi-build-and-boot/blob/master/README.md [↩](#a1)

<b id="f2">2</b>
please replace 192.168.178 in vagrantfile and playbook.yml if your router uses another subnet [↩](#a2)
