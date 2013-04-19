<?php
/**
*@file hook_tracker.drush.inc Drush command to show modules which implement a given hook.
*
*/
#WARNING!
#This is my first drush command, so please feedback to me any issues ;)


/**
* Core of command
*/
function hook_tracker_drush_command() {
	$items = array();

	$items['hook-tracker-list'] = array(
		#There is no need to define callback because it is defined by key in the line above
		//'callback' => 'drush_hook_tracker_show_modules',
		'aliases' => array('htl'),
		'description' => "Display modules which implements a hook given in parameter.",
		'arguments' => array(
              		'hook_name' => 'Hook you want to track',
            	),
		'examples' => array( 
              		'drush htl menu' => 'Display list of modules which use hook_menu',
           	),
		'bootstrap' => DRUSH_BOOTSTRAP_MAX, //Full bootstrap.
	);
	return $items;
}


/**
* Callback function for $items[show-modules]
*
* @param $hook_name Name of the hook we want to track
*/
function drush_hook_tracker_show_modules ($hook_name = 'menu') {
	$hkn = $hook_name;
	//http://api.drupal.org/api/drupal/includes!module.inc/function/module_implements/7
	$list = module_implements($hkn);
	$order = 0;
	echo "\n";	
	echo ' Order of modules which implement hook_' . $hook_name . ": \n\n";
	foreach ($list as $mod_name) {
		print ' ' . $order++ . ' -> ' . $mod_name . "\n";
	}
}
