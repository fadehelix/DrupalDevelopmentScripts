#!/bin/bash

#check if user is the root
if (( EUID != 0 )); then
   echo "You must be root to execute this script. Bye ;)" 1>&2
   exit 100
fi


#Get vhost nad user names
echo  -n "Type in a vhost address: "
read vh
domain=${vh##*.}
sitename=${vh%*.$domain}
echo -n "Type in a user of vhost: "
read vhowner

#Check if vhost exists
if ( grep -qi $vh /etc/hosts ); then
	echo "Such vhost exists. Please choose a different name"
	exit 1
fi

#input validation
# -z mean: is empty
if [ -z $sitename ]; then
	echo "Sorry, but site name can't be empty. Try again."
	exit 1
fi
if [ -z $domain ]; then
  echo "Sorry, but domain name can't be empty. Try again."
	exit 1
fi

if [ -z $vhowner ]; then
	echo "Sorry, but You must type user name. Try again."
	exit 1
fi

#make vhost directory
mkdir -p /var/www/$vh/public_html


#change owner
#chown -R $vhowner:www-data /var/www/$sitename$domain/public_html

#logs
mkdir /var/log/apache2/$vh/


#vhost configuration
echo "<VirtualHost *:80>
 DocumentRoot /var/www/$vh/public_html/
 ServerName $vh
 ServerAlias $vh www.$vh
 <Directory /var/www/$vh/public_html/ >
  allow from all
  Options +Indexes FollowSymLinks
 </Directory>

 #plik z logami
 ErrorLog /var/log/apache2/$vh/error.log

 LogLevel warn

 CustomLog /var/log/apache2/$vh/access.log combined

</VirtualHost>" > /etc/apache2/sites-available/$vh


echo  127.0.0.1    $vh >>/etc/hosts

#enable vhost
a2ensite $vh

/etc/init.d/apache2 restart

#database
#confirmation to create database
read -p "Are You want to create database? " -n 1 -r
if ([[ $REPLY =~ ^[Yy]$ ]]) then

	echo -n ""
	echo -n "MySQL  user with create/drop database privilages : "
	read dbuser
	echo -n "MySQL user's password: "
	read dbuserpass

	mysql -u"$dbuser" -p"$dbuserpass" -e "create database $sitename;"
fi


######## DRUPAL SECTION #########

cd /var/www/$vh/public_html/

echo 'Downloading Drupal...'

#Download Drupal with modules which have defined in .make files
drush make https://raw.github.com/fadehelix/DrupalDevelopmentScripts/master/drush/default.make .

#translations
chmod g+r translations/*
chmod g+r profiles/minimal/translations/*
#files
mkdir sites/default/files
chmod g+w sites/default/files/

#prepare settings
cp sites/default/default.settings.php sites/default/settings.php
chmod g+w sites/default/settings.php

#ckeditor library
cp -r sites/all/libraries/cke/ckeditor/ckeditor/ sites/all/libraries/
rm -rf sites/all/libraries/cke

#change owner of all Drupal files
chown -R $vhowner:www-data *
chown    $vhowner:www-data .*
