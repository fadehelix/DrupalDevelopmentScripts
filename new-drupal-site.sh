#!/bin/bash

#check if user is the root
if (( EUID != 0 )); then
   echo "You must be root to execute this script. Bye ;)" 1>&2
   exit 100
fi


#Pobierz nazwe tworzonego vhosta i jednoczesnie usera
echo  -n "Type in a site name: "
read sitename
echo -n "Type in a domain e.g. .local (with dot): "
read domain
echo -n "Type in a user of vhost: "
read vhowner

#Check if vhost exists
if ( grep -qi $sitename$domain /etc/hosts ); then
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
mkdir -p /var/www/$sitename$domain/public_html


#change owner
chown -R $vhowner:www-data /var/www/$sitename$domain/public_html

#Utworz katalog z logami apacha dla vhosta
mkdir /var/log/apache2/$sitename$domain/


#utworzenie konfiguracji vhosta
echo "<VirtualHost *:80>
 DocumentRoot /var/www/$sitename$domain/public_html/
 ServerName $sitename$domain
 ServerAlias $sitename$domain www.$sitename$domain
 <Directory /var/www/$sitename$domain/public_html/ >
  allow from all
  Options +Indexes FollowSymLinks
 </Directory>

 #plik z logami
 ErrorLog /var/log/apache2/$sitename$domain/error.log

 LogLevel warn

 CustomLog /var/log/apache2/$sitename$domain/access.log combined

</VirtualHost>" > /etc/apache2/sites-available/$sitename$domain

#utworz dowiazanie
#ln -s "/etc/apache2/sites-available/$sitename /etc/apache2/sites-enabled/

echo  127.0.0.1    $sitename$domain >>/etc/hosts

a2ensite $sitename$domain

/etc/init.d/apache2 restart

#database
echo -n: "Uzytkownik bazy danych: "
read dbuser
echo -n "Haslo uzytkownika bazy danych: "
read dbuserpass

mysql -u$dbuser -p$dbuserpass -e "create database $sitename;"


#test vhosta
echo "<h1>Propsy! Utworzyles vhosta <span style='color:red'> ${sitename}${domain} </span> !!!</h1>" > /var/www/$sitename$domain/public_html/index.php

