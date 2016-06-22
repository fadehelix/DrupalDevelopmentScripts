<?php

/**
 * Implements hook_drush_command().
 */
function dbupdate_revert_drush_command() {
  
  $items['dbupdate-revert'] = array(
    'description' => 'Revert database schema to given hook_update_N state. Look at drupal_set_installed_schema_version drupal function',
    'aliases' => array('dbr'),
    'arguments' => array(
      'update-id' => 'N in last working hook_update_N',
      'module'    => 'Module where hook_update_N has been fired'
    ),
    'options' => array(),
    'examples' => array(
      'drush dbr mymodule 8100' => 'Revert mymodule_update_8101',
    ),
  );
  
  return $items;
}

/**
 * Callback for the dbupdate-revert command
 */
function drush_dbupdate_revert($module, $update_id) {
  
  // Check if arguments are given
  if(!isset($module)) {
    return drush_set_error('No module name given! Please try egain and set the module name');
  }
  if(!isset($update_id)) {
    return drush_set_error('No update id given! Please try again and set the update ID');
  }

  $args = array('drupal_set_installed_schema_version(' . $module . ', ' . $update_id . ')');
  $options = array();
  drush_invoke_process('@self', 'php-eval', $args, $options);
  
}
