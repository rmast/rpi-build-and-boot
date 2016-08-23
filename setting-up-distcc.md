

Setting up distcc
=================

To set up distcc in a way the RPi1 can distribute it's compile-jobs to a host with at least a quadcore-processor you can
```sh
sudo apt-get install distcc
```
on both environments.

On the ubuntu virtual machine:

enter the server-side settings

```sh
sudo vi /etc/default/distcc
```
The effective contents of this file in my working setup:
```sh
STARTDISTCC="true"
ALLOWEDNETS="127.0.0.1 192.168.0.0/16"
LISTENER="192.168.178.250"
NICE="10"
JOBS=""
ZEROCONF="false"
```
Download or [compile](http://elinux.org/RPi_Linaro_GCC_Compilation) an applicable [toolchain](https://releases.linaro.org/14.09/components/toolchain/binaries/) into the /home/vagrant - directory:
```sh
wget https://releases.linaro.org/14.09/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.xz
tar -xvf gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.xz --xz
```

The used crosscompilation toolchain has this prefix on my machine:
/home/vagrant/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/arm-linux-gnueabihf-

To be able for distccd to find the crosscompilation toolchain you can append the directory to the path in 
```sh
sudo vi /etc/rc3.d/S20distcc
```

My effective first line in that file looks like:
```sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/home/vagrant/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin
```

Then start the distcc daemon:
```sh
sudo /etc/init.d/distcc start
```



On the RPi1: 
```sh
sudo vi /etc/distcc/hosts
```
which solely will contain the address of the ubuntu virtual machine:
```sh
192.168.178.250
```

```sh
vi ~/.bashrc
```
add at the bottom:
```sh
export PATH=/usr/lib/distcc:$PATH
export DISTCC_SKIP_LOCAL_RETRY=1
export DISTCC_BACKOFF_PERIOD=0
export DISTCC_IO_TIMEOUT=3000
```

alter the links in /usr/lib/distcc to exactly match the names of the toolchain on the host for [crosscompilation]
(https://github.com/ethz-asl/odroid_ros/wiki/Distcc-for-crosscompilation):

```sh
sudo -s
cd /usr/lib/distcc
cat > arm-linux-gnueabihf-wrapper << EOF
#!/bin/bash
exec /usr/lib/distcc/arm-linux-gnueabihf-g\${0:\$[-2]} "\$@"
EOF
chmod a+x arm-linux-gnueabihf-wrapper
ln -sf arm-linux-gnueabihf-wrapper cc
ln -sf arm-linux-gnueabihf-wrapper gcc
ln -sf arm-linux-gnueabihf-wrapper g++
ln -sf arm-linux-gnueabihf-wrapper c++
cd -
exit
```

And now you should be able to start your make -j4 builds from your pi, to distribute them to the host.

--------------------------

Monitor the network traffic with
```sh
sudo apt-get install vnstat
vnstat --live
```

The network-throughput of the Pi can be boosted with a [USB-Gigabit-ethernet-dongle](http://www.jeffgeerling.com/blogs/jeff-geerling/getting-gigabit-networking)
