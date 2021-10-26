#!bin/bash

mkdir /matlab
mount -t cifs //fs.bmstu.ru/MATLAB /matlab -o username=guest,password='',uid=500,gid=500
echo "//fs.bmstu.ru/MATLAB  /matlab cifs credentials=/home/user/.smbc,uid=500,iocharset=utf8,nofail,_netdev   0   0" >> /etc/fstab
touch /home/user/.smbc
echo "username=guest" >> /home/user/.smbc
echo "password=" >> /home/user/.smbc
touch /home/user/.mna.sh
echo "sleep 120" >> /home/user/.mna.sh
echo "mount -a" >> /home/user/.mna.sh
echo "@reboot /home/user/.mna.sh" >> /etc/crontab
cd /matlab/Linux/R2020b
./install
