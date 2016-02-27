#!/bin/bash

#check if user is the root
if (( EUID != 0 )); then
   echo "You need the root access to execute this script. Sorry ;)" 1>&2
   exit 100
fi

user=$(whoami)

#Get vhost nad user names
echo -n  "Vhost address: "
read vh
domain=${vh##*.}
sitename=${vh%*.$domain}
echo -n "User with access permission to this vhost (default: $user ): "
read vhowner

echo -n "Vhost path [/var/www/]: "
read vp
path=${vp}


#Check if vhost exists
if ( grep -qi $vh /etc/hosts ); then
	echo "$(tput setaf 1)Such vhost exists.$(tput sgr 0) Please choose a different address"
	exit 1
fi

#input validation
# -z mean: is empty
if [ -z $sitename ]; then
	echo "$(tput setaf 1)Sorry, but site name can't be empty.$(tput sgr 0) Try again."
	exit 1
fi
if [ -z $domain ]; then
	echo "$(tput setaf 1)Sorry, but domain name can't be empty.$(tput sgr 0) Try again."
    exit 1
fi

if [ -z $vhowner ]; then
  #if user prompt is empty get current sustem user name
  $vhowner = $user
fi

if [ -z $vp  ]; then
	#if path is empty set default /var/www/
	$vp = "/var/www/"
fi

#make vhost directory
mkdir -p $vp$vh


#change owner
chown -R $vhowner:www-data $vp$sitename.$domain

#logs
mkdir /var/log/apache2/$vh/


#vhost configuration
echo "<VirtualHost *:80>
 DocumentRoot $vp$vh/
 ServerName $vh
 ServerAlias $vh www.$vh
 <Directory $vp$vh/ >
  Options Indexes FollowSymLinks
  AllowOverride All
  Require all granted
 </Directory>

 #plik z logami
 ErrorLog /var/log/apache2/$vh/error.log

 LogLevel warn

 CustomLog /var/log/apache2/$vh/access.log combined

</VirtualHost>" > "/etc/apache2/sites-available/$vh.conf"


echo  127.0.0.1    $vh >>/etc/hosts

#enable vhost
a2ensite $vh

/etc/init.d/apache2 restart

#database
#confirmation to create database
read -p "Do you want to create database? [y / n] " -n 1 -r
if ([[ $REPLY =~ ^[Yy]$ ]]) then

	echo -e "\n"
	echo -n "MySQL  user with create/drop database privilages : "
	read dbuser
	echo -n "\n MySQL user's password: "
	read dbuserpass

	mysql -u"$dbuser" -p"$dbuserpass" -e "create database $sitename;"
fi

echo -e "\n\n $(tput setaf 6)Success!$(tput sgr 0) \n " 
echo -e "$(tput setaf 2)New vhost $vh has been created!$(tput sgr 0) \n"
echo -e "$(tput setaf 2)New database $sitename has been created!$(tput sgr 0)"
