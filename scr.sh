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
   /etc/init.d/postgresql start
   apt-get update
   mkdir -p /var/lib/pgadmin3/ /var/log/pgadmin3/
   chmod +rwx pgadmin3-1.23.0-0.2.git705eb1b.fc33.aarch64.rpm
   ./pgadmin3-1.23.0-0.2.git705eb1b.fc33.aarch64.rpm
   apt-get install pgadmin3
   apt-get install pgadmin3-docs-all
   systemctl restart httpd
   systemctl enable postgresql
