#!/bin/bash
#delete vhost and database

#check if user is the root
if (( EUID != 0 )); then
   echo "You must be root to execute this script. Bye ;)" 1>&2
   exit 100
fi

#Show list of  existing vhosts
echo "vhosts list: "
grep 127.0.0.1 /etc/hosts

#type vhost name
echo -n "Type vhost address: "
read vh
domain=${vh##*.}
sitename=${vh%*.$domain}


#Check if vhost exists
if ( grep -q $vh /etc/hosts ); then
 echo "Vhost will be remove..."
else
	echo "Such vhost doesn't exists. Please choose a different vhost"
	exit 1
fi


#delete vhost's directories
rm -rf /var/www/$vh
rm -rf /var/log/apache2/$vh/

#make backup of /etc/hosts and delete entry with typed vhost
sed -i'.bak' "/$vh/d" /etc/hosts
#disable vhost
a2dissite $vh

rm /etc/apache2/sites-available/$vh


#delete database
echo -n "Database user name (with create/drop database privileges): "
read dbuser
echo -n "Database user's password: "
read dbuserpass

mysql -u$dbuser -p$dbuserpass -e "drop database $sitename;"

echo "Database removed"

/etc/init.d/apache2 restart
