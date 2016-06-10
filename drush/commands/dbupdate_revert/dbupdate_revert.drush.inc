<?php

/**
 * Implements hook_drush_command().
 */
function dbupdate_revert_drush_command() {
  
  $items['dbupdate-revert'] = array(
    'description' => 'Revert given given hook_update_n',
    'aliases' => array('dbr'),
    'arguments' => array(
      'update-id' => 'N in hook_update_N after revert (e.g. if you want to revert update 8101 then set update-id as 8100)',
      'module'    => 'Module where hook_update_N has been fired'
    ),
    'options' => array(),
    'examples' => array(
      'drush dbr mymodule 8101' => 'Revert mymodule_update_8101',
    ),
  );
  
  return $items;
}

/**
 * Callback for the dbupdate-revert-command command
 */
function drush_dbupdate_revert($module, $update_id) {
  
  // Check for correct argument
  if(!isset($module)) {
    return drush_set_error('No module name given! Please try egain and set the module name');
  }
  if(!isset($update_id)) {
    return drush_set_error('No update id given! Please try again and set the update ID');
  }

    $args = array('drupal_set_installed_schema_version('" . $module . "', ' . $update_id . ');');
    $options = array();
  drush_invoke_process('@self', 'php-eval', $args, $options);
  
}
