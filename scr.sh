#!bin/bash
   apt-get update
   apt-get install postgresql12 
   apt-get install postgresql12-contrib 
   apt-get install postgresql12-perl 
   apt-get install postgresql12-python 
   apt-get install postgresql12-server 
   apt-get install postgresql12-tcl 
   apt-get install postgresql12-1C-contrib  
   apt-get install postgresql12-1C-perl 
   apt-get install postgresql12-1C-python 
   apt-get install postgresql12-1C-server 
   apt-get install postgresql12-1C-tcl 
   apt-get update
   ./pgadmin3-1.23.0-0.2.git705eb1b.fc33.aarch64.rpm
   apt-get install pgadmin3
   apt-get install pgadmin3-docs-all 
   systemctl enable postgresql
   apt-get update
   chmod +rwx /lib/systemd/systemd-sysv-install
