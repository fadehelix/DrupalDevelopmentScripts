##ABOUT

Main goal of this project is to extremely speed up Drupal instalation process on dev environments. 
new-drupal-site.sh allows you to create a virtual host, mysql database and download Drupal core with modules, which are defined in a default.make file. All of this can accomplished with just one command. Database creation is optional.

Sites installation process is  actually carried out by the browser.

##REQUIREMENTS
* Ubuntu/Kubuntu with sudo access
* Apache with standard configuration
* MySQL
* Drush5

##Drush commands:
* hook-tracker-list (htl): Display order of modules which implements a hook given in parameter. It's handy to debug your if you want to increase site's  performance (less enabled modules - less queries to database).

#### Are you disapointed ?
Feel free to fork and submit issues.
