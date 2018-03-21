## ABOUT

The main goal of this project is to speed up Drupal instalation process on dev environments by automation some of repetable tasks such as create new vhost, install new drupal instance, etc.

Sites installation process is  actually carried out by the browser.

### REQUIREMENTS
* Ubuntu/Kubuntu with sudo access
* Apache with standard configuration
* MySQL/MariaDB
* Drush

## Sync database and public files between drupal instances
1. Configure site aliases by edit `drush/sites/default.site.yml`
2. Run `./sync.sh`


### How to create new vhost?
```bash
sudo ./new-vhost
```
then set url address of your new vhost:
```bash
Vhost address: myvhost.local
```
Set vhost owner, which usually is your system user - let's say he is called 'jack' (/home/jack)
```bash
User with access permission to this vhost (default: root ): jack
```
Now you can choose if you want to have new database. If yes set your MySQL user and password when prompt.

### What if you need to only install, let's say, modules included in theme.make file?
It is easy. Just go to your drupal site directory and run following command:
```bash
drush make -y --no-core path/to/the/theme.make .
```

#### Are you disapointed ?
Feel free to fork and submit issues.
