#!/bin/bash
# Sync database and files between two sites defined as drush aliases
# This script assumes that theese aliases are "local" for local environemnt and "dev" for server one.

read -p "Do you want to sync databases? [y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	drush sql:sync @default.local @default.dev
fi

read -p "Do you want to sync public files? [y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	drush rsync @default.local:sites/default/files @default.dev:sites/default -- --delete --progress -vr
fi
