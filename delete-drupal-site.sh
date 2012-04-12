#!/bin/bash
#delete vhost and database

#check if user is the root
if (( EUID != 0 )); then
   echo "You must be root to execute this script. Bye ;)" 1>&2
   exit 100
fi

#Show existing vhosts at the start
echo "vhosts list: "
grep 127.0.0.1 /etc/hosts

#type vhost name
echo -n "Type vhost name: "
read sitename
echo -n "Type domain of this site with dot (e.g. .local): "
read domain

#Check if vhost exists
if ( grep -q $sitename$domain /etc/hosts ); then

else
	echo "Such vhost doesn't exists. Please choose a different vhost"
	exit 1
fi


#delete vhost's directories
rm -rf /var/www/${sitename}${domain}
rm -rf /var/log/apache2/$sitename$domain/

#make backup of /etc/hosts and delete entry with typed vhost
sed -i'.bak' "/$sitename$domain/d" /etc/hosts
#disable vhost
a2dissite ${sitename}${domain}

rm /etc/apache2/sites-available/$sitename$domain


#delete database
echo -n: "Database user name (with create/drop database privileges): "
read dbuser
echo -n "Database user's password: "
read dbuserpass

mysql -u$dbuser -p$dbuserpass -e "drop database $sitename;"

/etc/init.d/apache2 restart
