#! /bin/bash
echo "Enter Name of the parent directory"
read parent
echo "Enter Name of the sub directory"
read subdir
sudo mkdir -p /$parent/$subdir
echo "Enter name of dev directory"
read dev
sudo mkdir -p /$parent/$subdir/$dev/	
cd /$parent/$subdir/$dev/
sudo mknod -m 666 null c 1 3
sudo mknod -m 666 tty c 5 0
sudo mknod -m 666 zero c 1 5
sudo mknod -m 666 random c 1 8
sudo chown root:root /$parent/$subdir
sudo chmod 0755 /$parent/$subdir
sudo ls -ld /$parent/$subdir
echo "Setup Interactive Shell for SSH Chroot Jail create bin directory"
read bin
sudo mkdir -p /$parent/$subdir/$bin
sudo cp -v /bin/bash  /$parent/$subdir/$bin
echo " identify bash required shared libs, as below and copy them into the lib directory"
sudo ldd /bin/bash
echo "Enter name of lib directory"
read lib64
sudo  mkdir -p /$parent/$subdir/$lib64
sudo find / -name libtinfo.so.5 -exec cp {} /$parent/$subdir/$lib64 \;
sudo find / -name libdl.so.2 -exec cp {} /$parent/$subdir/$lib64 \;
sudo find / -name libc.so.6 -exec cp {} /$parent/$subdir/$lib64 \;
sudo find / -name ld-linux-x86-64.so.2 -exec cp {} /$parent/$subdir/$lib64 \;
echo " create ssh user "
echo "Enter user Name"
read username
sudo useradd $username
echo "Enter password"
sudo passwd $username
echo "Create the chroot jail general configurations directory"
read etc
sudo mkdir -p /$parent/$subdir/$etc
sudo cp -vf /etc/passwd /$parent/$subdir/$etc
sudo cp -vf /etc/group /$parent/$subdir/$etc
sudo echo "Match User $username" >> /etc/ssh/sshd_config
sudo echo ChrootDirectory /$parent/$subdir >> /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo ssh $username@localhost
echo "Create SSH User’s Home Directory and Add Linux Commands"
read home
mkdir -p /$parent/$subdir/$home/$username
sudo chown -R $username:$username /$parent/$subdir/$home/$username
sudo chmod -R 0700 /$parent/$subdir/$home/$username
sudo cp -v /bin/ls /$parent/$subdir/$bin
sudo cp -v /bin/date /$parent/$subdir/$bin
sudo cp -v /bin/mkdir /$parent/$subdir/$bin
sudo ldd /bin/ls
sudo cp -v /lib64/{libselinux.so.1,libcap.so.2,libacl.so.1,libc.so.6,libpcre.so.1,libdl.so.2,ld-linux-x86-64.so.2,libattr.so.1,libpthread.so.0} /$parent/$subdir/$lib64







