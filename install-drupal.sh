#!/bin/bash

#To use this script you have to prepare:
# - virtualhost
# - database


#check if user is the root
if (( EUID != 0 )); then
   echo "You must be root to execute this script. Bye ;)" 1>&2
   exit 100
fi


#Get required data from user
echo  -n "Type in a vhost address: "
read vh
domain=${vh##*.}
sitename=${vh%*.$domain}
echo  -n "Database name: "
read dbname
echo  -n "Database user: "
read dbuser
echo  -n "Database password: "
read dbpass

projectdir="/var/www/$vh/public_html/"

cd $projectdir

#Check if Drush is installed
if ! type -p drush > /dev/null; then
  echo -n 'Drush is not installed'
  echo -n 'Installing Drush'
  pear channel-discover pear.drush.org
  pear install drush/drush
fi

echo 'Downloading Drupal and most useful modules...'
#Download Drupal with modules which have defined in .make files
drush make https://raw.github.com/fadehelix/DrupalDevelopmentScripts/master/drush/default.make .



#translations
#chmod g+r translations/*
#chmod g+r profiles/minimal/translations/*


#files
mkdir sites/default/files
chmod g+w sites/default/files/

#prepare settings
cp sites/default/default.settings.php sites/default/settings.php
chmod g+w sites/default/settings.php


#install drupal
drush si standard --account-name=admin account-pass='admin@1234' --db-url=mysql://"$dbuser":"$dbpass"@localhost/"$dbname" -y

#change owner of all Drupal files
chown -R $vhowner:www-data *
chown    $vhowner:www-data .*

#Some site customization after installation
drush en admin_menu boxes context views -y
drush dis toolbar -y